%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

/* Definitions for regular expressions */
identifier  [a-zA-Z_][a-zA-Z0-9_]*
number      [0-9]+
whitespace  [ \t\n]+

%%

"int"         { return INT; }
"if"          { return IF; }
"else"        { return ELSE; }
"while"       { return WHILE; }

{identifier}  { 
    yylval.str = strdup(yytext); 
    return IDENTIFIER; 
}
{number}      { 
    yylval.num = atoi(yytext); 
    return NUMBER; 
}

";"           { return SEMICOLON; }
","           { return COMMA; }
"="           { return ASSIGN; }
"=="          { return EQ; }
"!="          { return NEQ; }
"<"           { return LT; }
">"           { return GT; }
"<="          { return LE; }
">="          { return GE; }
"+"           { return PLUS; }
"-"           { return MINUS; }
"*"           { return MULTIPLY; }
"/"           { return DIVIDE; }

"("           { return LPAREN; }
")"           { return RPAREN; }
"{"           { return LBRACE; }
"}"           { return RBRACE; }

{whitespace}  { /* ignore whitespace */ }

.             { 
    printf("Invalid character: %s\n", yytext); 
}

%%

int yywrap() {
    return 1;
}
