%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

#define MAX_TOKENS 100 

typedef struct {
    char symbol[32]; 
    char type[10]; 
} Token;

Token token_array[MAX_TOKENS]; 
int token_count = 0; 

void yyerror(char *s);
void add_token(char *symbol, char *type);
void print_tokens();
%}


identifier [a-zA-Z][a-zA-Z0-9_]* 
%%

";"		{add_token(";","Semicolon"); return ';';}	

":="          { add_token(yytext, "Operator"); return ASSIGN; }
"+"          { add_token("+", "Operator"); return PLUS; }
"-"          { add_token("-", "Operator"); return MINUS; }
"*"          { add_token("*", "Operator"); return MUL; }
"/"          { add_token("/", "Operator"); return DIV; }

"and"        { add_token("and", "AND"); return AND; }
"or"         { add_token("or", "OR"); return OR; }

"if"         { add_token("if", "Keyword"); return IF; }
"else"       { add_token("else", "Keyword"); return ELSE; }
"while"      { add_token("while", "Keyword"); return WHILE; }

"<"          { add_token("<", "relop"); return LT; }
">"          { add_token(">", "relop"); return GT; }

"("          { add_token("(", "LPAREN"); return '('; }
")"          { add_token(")", "RPAREN"); return ')'; }
"{"          { add_token("{", "LBRACE"); return '{'; }
"}"          { add_token("}", "RBRACE"); return '}'; }

{identifier} {
    yylval.str = strdup(yytext);
    add_token(yytext, "ID");
    
    return ID;
}

[0-9]+ {
    add_token(yytext, "Number");
    yylval.num = atoi(yytext);
    return NUM;
}

[ \t\n] ; 
. {
    printf("Unexpected character: %s\n", yytext);
}

%% 

void add_token(char *symbol, char *type) {
    if (token_count < MAX_TOKENS) {
        strncpy(token_array[token_count].symbol, symbol,32);
        strncpy(token_array[token_count].type,type,10);
        token_count++;
    } else {
        printf("Token limit reached. Cannot add more tokens.\n");
    }
}

void print_tokens() {
    printf("Tokens:\n");
    for (int i = 0; i < token_count; i++) {
        printf("|%-14s|%-15s|\n", token_array[i].symbol, token_array[i].type);
    }
}

int yywrap() {
    return 1;
}

