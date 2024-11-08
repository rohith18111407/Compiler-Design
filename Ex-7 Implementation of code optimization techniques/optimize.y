%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char *s);
int yylex();

typedef struct {
    char *name;
    char *expression;
} entry;

entry symbol_table[100];
int symbol_table_index = 0;

int lookup(char *expr);
void add_expression(char *name, char *expr);
char *concatenate(char *a, char *op, char *b);
int is_constant(char *name);

%}

%union {
    int intval;
    char *strval;
}

%token <intval> NUMBER
%token <strval> VARIABLE
%token ASSIGN MULTIPLY ADD POWER NEWLINE

%left ADD
%left MULTIPLY
%right POWER

%type <strval> expression line

%%

input:
    | input line NEWLINE
    ;

line:
      VARIABLE ASSIGN expression {
          int index = lookup($3);
          if (index == -1) {
              // Expression not yet seen, so we add it
              add_expression($1, $3);
              printf("%s = %s\n", $1, $3);
          } else {
              // Expression already exists, skip duplicate
              printf("// Duplicate of %s; skipping %s\n", symbol_table[index].name, $1);
          }
      }
    ;

expression:
      NUMBER {
          char buffer[12];
          sprintf(buffer, "%d", $1);
          $$ = strdup(buffer);
      }
    | VARIABLE {
          $$ = strdup($1);
      }
    | expression MULTIPLY expression {
          if (is_constant($1) && is_constant($3)) {
              char buffer[12];
              sprintf(buffer, "%d", atoi($1) * atoi($3));
              $$ = strdup(buffer);
          } else if (strcmp($1, "1") == 0) $$ = $3;
          else if (strcmp($3, "1") == 0) $$ = $1;
          else {
              $$ = concatenate($1, "*", $3);
          }
      }
    | expression ADD expression {
          if (is_constant($1) && is_constant($3)) {
              char buffer[12];
              sprintf(buffer, "%d", atoi($1) + atoi($3));
              $$ = strdup(buffer);
          } else if (strcmp($1, "0") == 0) $$ = $3;
          else if (strcmp($3, "0") == 0) $$ = $1;
          else {
              $$ = concatenate($1, "+", $3);
          }
      }
    | expression POWER expression {
          if (strcmp($3, "2") == 0) $$ = concatenate($1, "*", $1);
          else $$ = concatenate($1, "**", $3);
      }
    ;

%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {

}

int lookup(char *expr) {
    for (int i = 0; i < symbol_table_index; i++) {
        if (strcmp(symbol_table[i].expression, expr) == 0) {
            return i;
        }
    }
    return -1;
}

void add_expression(char *name, char *expr) {
    symbol_table[symbol_table_index].name = strdup(name);
    symbol_table[symbol_table_index].expression = strdup(expr);
    symbol_table_index++;
}

int is_constant(char *name) {
    for (int i = 0; name[i] != '\0'; i++) {
        if (name[i] < '0' || name[i] > '9') return 0;
    }
    return 1;
}

char *concatenate(char *a, char *op, char *b) {	
    char *result = malloc(strlen(a) + strlen(op) + strlen(b) + 1);
    sprintf(result, "%s%s%s", a, op, b);
    return result;
}
