/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    IDEN = 258,
    STRING_LITERAL = 259,
    INT_LITERAL = 260,
    COLON = 261,
    INICIO = 262,
    ROUTINE = 263,
    CALL = 264,
    VAR = 265,
    TYPE_INT = 266,
    TYPE_STRING = 267,
    IF = 268,
    ELSE = 269,
    WHILE = 270,
    SUBIR = 271,
    DESCER = 272,
    INCLINAR = 273,
    NAVEGAR_PARA = 274,
    ACELERAR = 275,
    PARAR = 276,
    STATUS = 277,
    DIZER = 278,
    EQ = 279,
    NEQ = 280,
    LEQ = 281,
    GEQ = 282,
    LT = 283,
    GT = 284,
    ASSIGN = 285,
    PLUS = 286,
    MINUS = 287,
    TIMES = 288,
    DIVIDE = 289,
    AND = 290,
    OR = 291,
    LPAREN = 292,
    RPAREN = 293,
    LBRACE = 294,
    RBRACE = 295,
    COMMA = 296,
    SEMICOLON = 297
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 189 "parser.y"

    int intValue;
    char* strValue;
    char* typeStr;

#line 106 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
