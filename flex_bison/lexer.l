%{
#include "parser.tab.h"
#define YYDEBUG 1

%}

%option yylineno
%option noyywrap

%%
"submergir"                { return SUBMERGIR; }
"emergir"                  { return EMERGIR; }
"ajustar_inclinacao"       { return AJUSTAR_INCLINACAO; }
"ativar_propulsor"         { return ATIVAR_PROPULSOR; }
"ajustar_profundidade"     { return AJUSTAR_PROFUNDIDADE; }
"ajustar_posicao"          { return AJUSTAR_POSICAO; }
"||"                       { return OR; }
"var"                      { return VAR; }
"Println"                  { return PRINTLN; }
"if"                       { return IF; }
"else"                     { return ELSE; }
"for"                      { return LOOP; }
"int"                      { return INT; } // Deve ser reconhecido antes de IDEN
"string"                   { return STRING; }
"<"                        { return LESS_THAN; }
">"                        { return GREATER_THAN; }
"=="                       { return DB_EQUAL; }
"="                        { return EQUAL; }
";"                        { return SEMICOLON; }
"+"                        { return PLUS; }
"-"                        { return MINUS; }
"*"                        { return MULTIPLY; }
"/"                        { return DIVIDE; }
"("                        { return LPAREN; }
")"                        { return RPAREN; }
","                        { return COMMA; }
"{"                        { return LBRACE; }
"}"                        { return RBRACE; }
"&&"                       { return AND; }
"\n"                       { return NEWLINE; }
[a-zA-Z_][a-zA-Z0-9_]*     { return IDEN; }
[0-9]+                     { yylval.intValue = atoi(yytext); return INT; }
\"[^\"]*\"                 { yylval.strValue = strdup(yytext + 1); yytext[yyleng - 1] = '\0'; return STRING_LITERAL; }
[0-9]+:[0-9]+:[0-9]+	   { yylval.strValue = strdup(yytext); return TIME; }
"//".*                     ;  // Ignorar comentários
[ \t]                      ;  // Ignorar espaços em branco

%%