%{
#include "intermediate.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%% 
"and"     { return AND; }
"or"      { return OR; }
":="      { return ASSIGN; }
"+"       { return PLUS; }
"-"       { return MINUS; }
"*"       { return MULT; }
"/"       { return DIV; }
"<"       { return LT; }
"("       { return LPAREN; }
")"       { return RPAREN; }
";"       { return SEMICOLON; }
[0-9]+               { yylval.num = atoi(yytext); return NUM; }
[a-zA-Z][a-zA-Z0-9]* { yylval.id = strdup(yytext); return ID; }
[ \t\n]+  { /* ignore whitespace */ }
.         { printf("Unknown character: %s\n", yytext); }




%% 

int yywrap() {
    return 1;
}