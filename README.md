PROGRAM          = { STATEMENT } ;

STATEMENT        = ASSIGNMENT
                   PRINT
                   VARIABLE
                   SUBMARINE_CONTROLLER
                   SUBMARINE_COMMAND
                   IF
                   LOOP
                   COMMENT ;

BLOCK            = "{" { STATEMENT } "}" ;

SUBMARINE_CONTROLLER = "submergir"
                       "emergir"
                       "ajustar_inclinacao" ;

SUBMARINE_COMMAND = "ativar_propulsor" "(" INT ")"
                    "ajustar_profundidade" "(" INT ")"
                    "ajustar_posicao" "(" INT "," INT ")" ;

VARIABLE         = "var" IDENTIFIER TYPE ;

TYPE             = ":" ("int" | "string") ;

ASSIGNMENT       = IDENTIFIER "=" EXPRESSION ;

PRINT            = ("Print" | "Println") "(" PRINT_ARG { "," PRINT_ARG } ")" ;

PRINT_ARG        = EXPRESSION | STR ;

IF               = "if" "(" BOOLEXP ")" BLOCK [ "else" BLOCK ] ;

LOOP             = "for" IDENTIFIER "=" EXPRESSION ";" BOOLEXP ";" IDENTIFIER "=" EXPRESSION BLOCK ;

BOOLEXP          = EXPRESSION { ("<" | ">" | "==" | "&&" | "||") EXPRESSION } ;

EXPRESSION       = TERM { ("+" | "-") TERM } ;

TERM             = FACTOR { ("*" | "/") FACTOR } ;

FACTOR           = [ "+" | "-" ] ( INT | IDENTIFIER | "(" EXPRESSION ")" ) ;

IDENTIFIER       = LETTER { LETTER | DIGIT | "_" } ;

INT              = DIGIT { DIGIT } ;

STR              = '"' { LETTER | DIGIT | SPACE | SYMBOL } '"' ;

COMMENT          = "//" { ANY_CHARACTER } "\n" ;

RESERVED_WORDS   = "var" | "if" | "else" | "for"
                   "Print" | "Println"
                   "submergir" | "emergir" | "ajustar_inclinacao"
                   "ativar_propulsor" | "ajustar_profundidade" | "ajustar_posicao" ;

LETTER           = "a" | ... | "z" | "A" | ... | "Z" ;

DIGIT            = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ;

SPACE            = " " ;

SYMBOL           = "!" | "?" | "." | "," | ":" | ";" | "-" | "_" | "'" | "+" | "*" | "/" | "=" ;

ANY_CHARACTER    = LETTER | DIGIT | SPACE | SYMBOL ;
