%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

char global_strings[10000] = "";
char dynamic_strings[10000] = "";  // <-- NOVO BUFFER


int str_counter = 0;
int while_counter = 0;
int if_counter = 0;

char *fmt_nav_label, *fmt_acc_label, *fmt_stat_label, *fmt_int_label;
int fmt_nav_size, fmt_acc_size, fmt_stat_size, fmt_int_size;

FILE* output;

void declarar_constante_string_formatada_fixa(char* texto_formatado, char* rotulo_out, int* tamanho_out) {
    sprintf(rotulo_out, "str%d", str_counter);
    int tamanho = strlen(texto_formatado) + 2;
    *tamanho_out = tamanho;

    char declaracao[512];
    sprintf(declaracao, "@%s = private unnamed_addr constant [%d x i8] c\"%s\\0A\\00\"\n",
            rotulo_out, tamanho, texto_formatado);

    strcat(global_strings, declaracao);  // Apenas adiciona à string global
    str_counter++;
}

void declarar_constante_string_formatada_dinamica(char* texto_formatado, char* rotulo_out, int* tamanho_out) {
    sprintf(rotulo_out, "str%d", str_counter);
    int tamanho = strlen(texto_formatado) + 2;
    *tamanho_out = tamanho;

    char declaracao[512];
    sprintf(declaracao, "@%s = private unnamed_addr constant [%d x i8] c\"%s\\0A\\00\"\n",
            rotulo_out, tamanho, texto_formatado);

    strcat(dynamic_strings, declaracao);  // salva aqui para imprimir depois, fora de @main
    str_counter++;
}

void start_codegen() {
    output = fopen("output.ll", "w");
    fprintf(output, "; LLVM IR gerado pelo compilador submarino\n");
    fprintf(output, "declare i32 @printf(i8*, ...)\n");

    // strings fixas
    char r_nav[50], r_acc[50], r_stat[50], r_int[50];
    declarar_constante_string_formatada_fixa("[NAV] indo para (%d,%d)", r_nav, &fmt_nav_size);
    declarar_constante_string_formatada_fixa("[NAV] acelerando: %d", r_acc, &fmt_acc_size);
    declarar_constante_string_formatada_fixa("[STATUS] %s", r_stat, &fmt_stat_size);
    declarar_constante_string_formatada_fixa("%d", r_int, &fmt_int_size);

    fmt_nav_label = strdup(r_nav);
    fmt_acc_label = strdup(r_acc);
    fmt_stat_label = strdup(r_stat);
    fmt_int_label = strdup(r_int);

    // imprime strings globais ANTES da main
    fprintf(output, "%s", global_strings);

    fprintf(output, "define i32 @main() {\n");
}

void end_codegen() {
    fprintf(output, "  ret i32 0\n}\n");

    fprintf(output, "%s", dynamic_strings);

    fclose(output);
}

void declare_var(char* name, char* type) {
    fprintf(output, "  ; Declarando variável %s do tipo %s\n", name, type);
    fprintf(output, "  %%%s = alloca i32\n", name);
}

void assign_int(char* name, int value) {
    fprintf(output, "  ; Atribuindo %d à variável %s\n", value, name);
    fprintf(output, "  store i32 %d, i32* %%%s\n", value, name);
}

void dizer_string(char* texto) {
    char rotulo[50];
    int tamanho;

    declarar_constante_string_formatada_dinamica(texto, rotulo, &tamanho);

    fprintf(output, "  ; Imprimindo mensagem: \"%s\"\n", texto);
    fprintf(output,
        "  %%tmp%d = call i32 (i8*, ...) @printf(i8* getelementptr ([%d x i8], [%d x i8]* @%s, i32 0, i32 0))\n",
        str_counter - 1, tamanho, tamanho, rotulo);
}

void dizer_variavel(char* varname) {
    fprintf(output, "  ; Imprimindo variável %s\n", varname);
    fprintf(output, "  %%load_%s = load i32, i32* %%%s\n", varname, varname);
    fprintf(output,
    "  %%tmp_printf_%s = call i32 (i8*, ...) @printf(i8* getelementptr ([%d x i8], [%d x i8]* @%s, i32 0, i32 0), i32 %%load_%s)\n",
    varname, fmt_int_size, fmt_int_size, fmt_int_label, varname);
}

void gerar_while_inicio() {
    fprintf(output, "  br label %%cond%d\n", while_counter);
    fprintf(output, "cond%d:\n", while_counter);
}

void gerar_while_cond(char* varname, int limite) {
    fprintf(output, "  %%load_%s_%d = load i32, i32* %%%s\n", varname, while_counter, varname);
    fprintf(output, "  %%cmp_%d = icmp slt i32 %%load_%s_%d, %d\n", while_counter, varname, while_counter, limite);
    fprintf(output, "  br i1 %%cmp_%d, label %%loop_body%d, label %%loop_end%d\n", while_counter, while_counter, while_counter);
    fprintf(output, "loop_body%d:\n", while_counter);
}

void gerar_while_fim() {
    fprintf(output, "  br label %%cond%d\n", while_counter);
    fprintf(output, "loop_end%d:\n", while_counter);
    while_counter++;
}

void gerar_if_comparacao(char* varname, int valor) {
    fprintf(output, "  %%load_%s_if%d = load i32, i32* %%%s\n", varname, if_counter, varname);
    fprintf(output, "  %%cmp_if%d = icmp slt i32 %%load_%s_if%d, %d\n", if_counter, varname, if_counter, valor);
    fprintf(output, "  br i1 %%cmp_if%d, label %%if_then%d, label %%if_else%d\n", if_counter, if_counter, if_counter);
    fprintf(output, "if_then%d:\n", if_counter);
}

void gerar_if_else() {
    fprintf(output, "  br label %%if_end%d\n", if_counter);
    fprintf(output, "if_else%d:\n", if_counter);
}

void gerar_if_fim() {
    fprintf(output, "  br label %%if_end%d\n", if_counter);
    fprintf(output, "if_end%d:\n", if_counter);
    if_counter++;
}

void gerar_navegar_para(char* x, char* y) {
    fprintf(output, "  ; navegando para coordenadas %s, %s\n", x, y);
    int is_x_lit = isdigit(x[0]);
    int is_y_lit = isdigit(y[0]);
    char xval[32], yval[32];

    if (is_x_lit) strcpy(xval, x);
    else {
        fprintf(output, "  %%load_%s_x = load i32, i32* %%%s\n", x, x);
        sprintf(xval, "%%load_%s_x", x);
    }

    if (is_y_lit) strcpy(yval, y);
    else {
        fprintf(output, "  %%load_%s_y = load i32, i32* %%%s\n", y, y);
        sprintf(yval, "%%load_%s_y", y);
    }

    fprintf(output,
    "  %%tmp_nav = call i32 (i8*, ...) @printf(i8* getelementptr ([%d x i8], [%d x i8]* @%s, i32 0, i32 0), i32 %s, i32 %s)\n",
    fmt_nav_size, fmt_nav_size, fmt_nav_label, xval, yval);
}

void gerar_acelerar(int val) {
    fprintf(output, "  ; acelerando com %d\n", val);
    fprintf(output,
    "  %%tmp_acc = call i32 (i8*, ...) @printf(i8* getelementptr ([%d x i8], [%d x i8]* @%s, i32 0, i32 0), i32 %d)\n",
    fmt_acc_size, fmt_acc_size, fmt_acc_label, val);
}

void iniciar_rotina(char* nome) {
    fprintf(output, "define void @%s() {\n", nome);
}

void encerrar_rotina() {
    fprintf(output, "  ret void\n}\n");
}

void chamar_rotina(char* nome) {
    fprintf(output, "  call void @%s()\n", nome);
}

void yyerror(const char *s);
extern int yylex();
%}

%union {
    int intValue;
    char* strValue;
    char* typeStr;
}
%type <intValue> EXPRESSION
%start PROGRAM

%token <strValue> IDEN STRING_LITERAL
%token <intValue> INT_LITERAL
%token COLON

%token INICIO ROUTINE CALL VAR TYPE_INT TYPE_STRING
%token IF ELSE WHILE
%token SUBIR DESCER INCLINAR NAVEGAR_PARA ACELERAR PARAR STATUS DIZER

%token EQ NEQ LEQ GEQ LT GT ASSIGN
%token PLUS MINUS TIMES DIVIDE AND OR

%token LPAREN RPAREN LBRACE RBRACE COMMA SEMICOLON
%type <typeStr> TYPE

%%

PROGRAM : DECLS ;

DECLS : DECL
      | DECLS DECL ;

DECL : INICIO LPAREN RPAREN BLOCK
     | ROUTINE_DECL ;

BLOCK : LBRACE STATEMENTS_OPT RBRACE ;

STATEMENTS_OPT : /* vazio */
               | STATEMENTS ;

STATEMENTS : STATEMENT SEMICOLON
           | STATEMENTS STATEMENT SEMICOLON ;

STATEMENT     : COMMAND
              | SAY
              | VARIABLE_DECL
              | ASSIGNMENT
              | IF_STATEMENT
              | WHILE_STATEMENT
              | ROUTINE_DECL
              | ROUTINE_CALL ;

COMMAND       : SUBIR
              | DESCER
              | INCLINAR LPAREN INT_LITERAL RPAREN
              | NAVEGAR_PARA LPAREN IDEN COMMA INT_LITERAL RPAREN {
                    char val1[32], val2[32];
                    strcpy(val1, $3);
                    sprintf(val2, "%d", $5);
                    gerar_navegar_para(val1, val2);
                }
              | NAVEGAR_PARA LPAREN INT_LITERAL COMMA IDEN RPAREN {
                    char val1[32], val2[32];
                    sprintf(val1, "%d", $3);
                    strcpy(val2, $5);
                    gerar_navegar_para(val1, val2);
                }
              | NAVEGAR_PARA LPAREN IDEN COMMA IDEN RPAREN {
                    gerar_navegar_para($3, $5);
                }
              | ACELERAR LPAREN INT_LITERAL RPAREN {
                    gerar_acelerar($3);
              }
              | PARAR
              | STATUS ;

SAY : DIZER LPAREN STRING_LITERAL RPAREN {
        dizer_string($3);
     }
    | DIZER LPAREN IDEN RPAREN {
        dizer_variavel($3);
     };

VARIABLE_DECL : VAR IDEN COLON TYPE {
    if (strcmp($4, "int") == 0) {
        declare_var($2, $4);
    } else {
        fprintf(stderr, "Tipo não suportado: %s\n", $4);
        exit(1);
    }
};

TYPE : TYPE_INT { $$ = "int"; }
// | TYPE_STRING { $$ = "string"; } // futuro suporte

ASSIGNMENT : IDEN ASSIGN EXPRESSION {
    if ($3 != -9999) {
        assign_int($1, $3);
    } else {
        fprintf(output, "  store i32 %%tmp_add_%s, i32* %%%s\n", $1, $1);
    }
};

EXPRESSION : INT_LITERAL { $$ = $1; }
           | IDEN {
               fprintf(output, "  %%load_%s = load i32, i32* %%%s\n", $1, $1);
               fprintf(output, "  %%tmp_expr = add i32 %%load_%s, 0\n", $1);
               $$ = -9999;
           }
           | IDEN PLUS INT_LITERAL {
               fprintf(output, "  %%load_%s = load i32, i32* %%%s\n", $1, $1);
               fprintf(output, "  %%tmp_add_%s = add i32 %%load_%s, %d\n", $1, $1, $3);
               $$ = -9999;
           };

IF_STATEMENT : IF IDEN LT INT_LITERAL {
        gerar_if_comparacao($2, $4);
    } BLOCK ELSE {
        gerar_if_else();
    } BLOCK {
        gerar_if_fim();
    };

WHILE_STATEMENT : WHILE IDEN LT INT_LITERAL {
        gerar_while_inicio();
        gerar_while_cond($2, $4);
    } BLOCK {
        gerar_while_fim();
    };

ROUTINE_DECL : ROUTINE IDEN {
        iniciar_rotina($2);
    } BLOCK {
        encerrar_rotina();
    };

ROUTINE_CALL : CALL IDEN {
        chamar_rotina($2);
    };

%%

void yyerror(const char *s) {
    extern int yylineno;
    extern char* yytext;
    fprintf(stderr, "Erro (%s): símbolo \"%s\" na linha %d\n", s, yytext, yylineno);
}

int main() {
    start_codegen();
    yyparse();
    end_codegen();
    return 0;
}