%{
#include "parser.tab.h"
#include <string.h>
%}

%option yylineno
%option noyywrap

%%
"inicio"                  { return INICIO; }
"routine"                 { return ROUTINE; }    // rotina declarativa
"var"                     { return VAR; }
"int"                     { return TYPE_INT; }
"string"                  { return TYPE_STRING; }
"se"                      { return IF; }
"senao"                   { return ELSE; }
"enquanto"                { return WHILE; }

"subir"                   { return SUBIR; }
"descer"                  { return DESCER; }
"inclinar"                { return INCLINAR; }
"navegar_para"            { return NAVEGAR_PARA; }
"acelerar"                { return ACELERAR; }
"parar"                   { return PARAR; }
"status"                  { return STATUS; }
"dizer"                   { return DIZER; }

"=="                      { return EQ; }
"!="                      { return NEQ; }
"<="                      { return LEQ; }
">="                      { return GEQ; }
"<"                       { return LT; }
">"                       { return GT; }
"="                       { return ASSIGN; }
"+"                       { return PLUS; }
"-"                       { return MINUS; }
"*"                       { return TIMES; }
"/"                       { return DIVIDE; }
"&&"                      { return AND; }
"||"                      { return OR; }

"("                       { return LPAREN; }
")"                       { return RPAREN; }
"{"                       { return LBRACE; }
"}"                       { return RBRACE; }
","                       { return COMMA; }
":"                       { return COLON; }
";"                       { return SEMICOLON; }

\"[^\"]*\"  {
    yytext[yyleng - 1] = '\0';                // Remove aspas finais
    yylval.strValue = strdup(yytext + 1);     // Remove aspas iniciais
    return STRING_LITERAL;
}

[0-9]+                    { yylval.intValue = atoi(yytext); return INT_LITERAL; }
[a-zA-Z_][a-zA-Z0-9_]*    { yylval.strValue = strdup(yytext); return IDEN; }

"//".*                    ; // Comentários de linha
[ \t\r\n]+                ; // Espaços, tabs e quebras de linha ignorados
%%
