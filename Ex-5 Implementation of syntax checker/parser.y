%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex();

%}

%union {
    char *str;
    int num;
}

%token <str> IDENTIFIER
%token <num> NUMBER
%token INT IF ELSE WHILE
%token ASSIGN EQ NEQ LT GT LE GE PLUS MINUS MULTIPLY DIVIDE
%token SEMICOLON COMMA LPAREN RPAREN LBRACE RBRACE

%%

// Grammar rules
program:
    statements
    ;

statements:
    statement
    | statements statement
    ;

statement:
    declaration_statement
    | assignment_statement
    | conditional_statement
    | looping_statement
    ;

declaration_statement:
    INT identifier_list SEMICOLON
    ;

identifier_list:
    IDENTIFIER
    | identifier_list COMMA IDENTIFIER
    ;


assignment_statement:
    IDENTIFIER ASSIGN expression SEMICOLON
    ;

expression:
    expression PLUS term
    | expression MINUS term
    | term
    ;

term:
    term MULTIPLY factor
    | term DIVIDE factor
    | factor
    ;

factor:
    IDENTIFIER
    | NUMBER
    | LPAREN expression RPAREN
    ;

conditional_statement:
    IF LPAREN condition RPAREN statement
    | IF LPAREN condition RPAREN statement ELSE statement
    ;

condition:
    expression relational_operator expression
    ;

relational_operator:
    EQ | NEQ | LT | GT | LE | GE
    ;

looping_statement:
    WHILE LPAREN condition RPAREN LBRACE statements RBRACE
    ;

%%

// Error handling function
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    if (yyparse() == 0) {
        printf("Syntactically correct\n");
    } else {
        printf("Syntax error detected\n");
    }
    return 0;
}