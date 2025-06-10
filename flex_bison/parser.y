%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
extern int yylex();
%}

%union {
    int intValue;
    char* strValue;
}

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

%%

PROGRAM : INICIO LPAREN RPAREN BLOCK ROUTINES ;

ROUTINES : /* vazio */
         | ROUTINES ROUTINE_DECL ;

BLOCK         : LBRACE STATEMENTS RBRACE ;

STATEMENTS    : STATEMENT SEMICOLON
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
              | NAVEGAR_PARA LPAREN EXPRESSION COMMA EXPRESSION RPAREN
              | ACELERAR LPAREN INT_LITERAL RPAREN
              | PARAR
              | STATUS ;

SAY : DIZER LPAREN STRING_LITERAL RPAREN
    | DIZER LPAREN IDEN RPAREN ;

VARIABLE_DECL : VAR IDEN COLON TYPE ;

TYPE          : TYPE_INT | TYPE_STRING ;

ASSIGNMENT    : IDEN ASSIGN EXPRESSION ;

EXPRESSION    : TERM
              | EXPRESSION PLUS TERM
              | EXPRESSION MINUS TERM ;

TERM          : FACTOR
              | TERM TIMES FACTOR
              | TERM DIVIDE FACTOR ;

FACTOR : INT_LITERAL
       | STRING_LITERAL
       | IDEN
       | LPAREN EXPRESSION RPAREN ;

IF_STATEMENT  : IF BOOLEXP BLOCK
              | IF BOOLEXP BLOCK ELSE BLOCK ;

WHILE_STATEMENT : WHILE BOOLEXP BLOCK ;

BOOLEXP       : EXPRESSION REL_OP EXPRESSION
              | BOOLEXP AND BOOLEXP
              | BOOLEXP OR BOOLEXP ;

REL_OP        : EQ | NEQ | LT | GT | LEQ | GEQ ;

ROUTINE_DECL  : ROUTINE IDEN BLOCK ;

ROUTINE_CALL  : CALL IDEN ;

%%

void yyerror(const char *s) {
    extern int yylineno;
    extern char* yytext;
    fprintf(stderr, "Erro (%s): símbolo \"%s\" na linha %d\n", s, yytext, yylineno);
}

int main() {
    yyparse();
    return 0;
}