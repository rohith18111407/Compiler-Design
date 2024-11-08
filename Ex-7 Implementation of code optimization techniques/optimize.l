%{
#include "optimize.tab.h"
%}

digit    [0-9]+
variable [a-zA-Z][a-zA-Z0-9]*

%%

{digit}        { yylval.intval = atoi(yytext); return NUMBER; }
{variable}     { yylval.strval = strdup(yytext); return VARIABLE; }
"="            { return ASSIGN; }
"**"           { return POWER; }
"*"            { return MULTIPLY; }
"+"            { return ADD; }
\n             { return NEWLINE; }
[ \t]          { /* ignore whitespace */ }

.              { return yytext[0]; }

%%

int yywrap() {
    return 1;
}
