# LogComp-APS - Submarinos

## Sobre a linguagem desenvolvida

Este projeto apresenta uma linguagem de programação educacional desenvolvida para a disciplina de Lógica da Computação (2025.1), com foco em comandos para navegação e controle de submarinos simulados. O projeto compila códigos `.sub` para LLVM IR, que pode ser executado com ferramentas como `lli`.

A linguagem foi criada com o objetivo de aplicar conceitos de análise léxica, sintática e geração de código intermediário, utilizando as ferramentas Flex, Bison e LLVM IR.

## Requisitos

- `flex`
- `bison`
- `gcc`
- `llvm` (para execução com `lli`)

---

## EBNF da linguagem

```ebnf
(* Programa principal *)
programa       ::= { declaracao } ;

(* Declarações de topo: inicio ou rotina *)
declaracao     ::= "inicio" "(" ")" bloco
                 | "routine" identificador bloco ;  (* ambas sem ponto-e-vírgula *)

(* Bloco de código entre chaves *)
bloco          ::= "{" { comando ";" } "}" ;

(* Comandos válidos dentro de blocos *)
comando        ::= comando_basico
                 | comando_dizer
                 | declaracao_variavel
                 | atribuicao
                 | comando_if
                 | comando_while ;

(* Declaração de variável *)
declaracao_variavel ::= "var" identificador ":" tipo ;

tipo           ::= "int" ;

(* Atribuição de valor *)
atribuicao     ::= identificador "=" expressao ;

(* Expressões permitidas *)
expressao      ::= inteiro
                 | identificador
                 | identificador "+" inteiro ;

(* Comando de impressão *)
comando_dizer  ::= "dizer" "(" string_literal ")"
                 | "dizer" "(" identificador ")" ;

(* Estrutura condicional *)
comando_if     ::= "se" identificador "<" inteiro bloco
                   "senao" bloco ;

(* Estrutura de repetição *)
comando_while  ::= "enquanto" identificador "<" inteiro bloco ;

(* Comandos específicos da linguagem *)
comando_basico ::= "subir"
                 | "descer"
                 | "inclinar" "(" inteiro ")"
                 | "navegar_para" "(" expressao "," expressao ")"
                 | "acelerar" "(" inteiro ")"
                 | "parar"
                 | "status" ;

(* Tokens léxicos *)
identificador  ::= letra { letra | digito | "_" } ;
inteiro        ::= digito { digito } ;
string_literal ::= '"' { qualquer_caractere_exceto_aspas } '"' ;

letra          ::= "a" | ... | "z" | "A" | ... | "Z" | "_" ;
digito         ::= "0" | ... | "9" ;

```

## Exemplo de Códigos da Linguagem


Navegação com condicional
```
inicio() {
  var destino: int;
  destino = 7;
  dizer("Preparando para navegação");
  se destino < 10 {
    dizer("Destino curto. Acelerando...");
    acelerar(2);
    navegar_para(destino, 3);
  } senao {
    dizer("Destino longo. Aguardando...");
  }
}

```
Output:
```
Preparando para navegação
Destino curto. Acelerando...
[NAV] acelerando: 2
[NAV] indo para (7,3)
```


While com incremento e status
```
inicio() {
  var distacia: int;
  distacia = 0;
  dizer("Preparando para navegação");
  enquanto distacia < 3 {
    dizer("Navegando");
    distacia = distacia + 1;
  };
}

```
Output:
```
Navegando
Navegando
Navegando
```


Sequência de comandos marítimos
```
inicio() {
  dizer("Subindo...");
  subir;
  dizer("Descendo...");
  descer;
  dizer("Inclinando para manobra");
  inclinar(45);
  dizer("Parando...");
  parar;
}

```
Output:
```
Subindo...
Descendo...
Inclinando para manobra
Parando...
```

## Compilação e Execução

- **Compile:**
  ```
    flex lexer.l
    bison -d parser.y
    gcc -o submarino parser.tab.c lex.yy.c -lfl

  ```

- **Execute:**
  ```
   ./submarino < test.sub
  ```

- **Rode o LLVM IR:**
  ```
    lli output.ll

  ```
  

## Funcionalidades Implementadas

# Comandos da Linguagem

- **Declaração de variáveis:**  
  `var x : int`

- **Atribuição:**  
  `x = 10;`

- **Expressões:**  
  `x + 1`

- **Condicionais:**  
  `se x < 5 { ... } senao { ... }`

- **Laços de repetição:**  
  `enquanto x < 10 { ... }`

- **Definição de rotinas:**  
  `routine nome { ... }`

- **Chamadas de rotinas:**  
  `call nome;`
  Já existe um suporte para chamada de rotinas, mas a lógica não está completa. Próximo passo para uma V2!

- **Impressões:**
  - Texto fixo: `dizer("texto");`
  - Variáveis: `dizer(x);`

## ✅ Comandos Específicos do Domínio Submarino

- `subir;`, `descer;`, `inclinar(angulo);`  
- `navegar_para(x, y);`  
- `acelerar(velocidade);`  
- `parar;`, `status;`

> Todos os comandos são traduzidos para chamadas `@printf` em LLVM IR. Numa possível V2 podemos chamar rotians para cada uma delas.

