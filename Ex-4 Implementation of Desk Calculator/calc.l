%{
#include "calc.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}

%% 
[0-9]+     { yylval = atoi(yytext); return NUMBER; }
"+"        { return '+'; }
"-"        { return '-'; }
"*"        { return '*'; }
"/"        { return '/'; }
"^"        { return '^'; }
"("        { return '('; }
")"        { return ')'; }
[ \t\n]+   { /* ignore whitespace */ }
.          { printf("Unknown character: '%s'\n", yytext); }

%%

int yywrap() {
    return 1;
}