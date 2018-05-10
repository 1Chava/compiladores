%{
#include "libreria.h"
//#include <math.h>
int yylex(void);
void yyerror (char *);
%}
             
/* Declaraciones de BISON */
%union{
	int entero;
  char* texto;
  float decimal;
}

%token <entero> ENTERO
%token <texto> TEXTO
%token <decimal> DECIMAL
%type <entero> exp1
%type <decimal> exp2
%type <texto> exp3
  
%left '+''-'
%left '*''/'
%left '('')'';'            
/* Gramática */
%%
             
input:    /* cadena vacía */
        | input line         
;

line:     '\n'
        | exp1 '\n'  { printf ("\tresultado: %d\n", $1); }
        | exp2 '\n'  { printf ("\tresultado: %.2f\n", $1); }
        | exp3 '\n'  { printf ("\tresultado: %s\n", $1); }
;
             
exp1:     ENTERO	{ $$ = $1; }
	| exp1 '+' exp1        { $$ = $1 + $3;    }
	| exp1 '-' exp1        { $$ = $1 - $3;    }
  | exp1 '*' exp1        { $$ = $1 * $3;    }
;

exp2:     DECIMAL	{ $$ = $1; }
	| exp2 '+' exp2        { $$ = $1 + $3;    }
  | exp1 '+' exp2        { $$ = $1 + $3;    }
  | exp2 '+' exp1        { $$ = $1 + $3;    }
	| exp2 '-' exp2        { $$ = $1 - $3;    }
  | exp1 '-' exp2        { $$ = $1 - $3;    }
  | exp2 '-' exp1        { $$ = $1 - $3;    }
  | exp2 '*' exp2        { $$ = $1 * $3;    }
  | exp1 '*' exp2        { $$ = $1 * $3;    }
  | exp2 '*' exp1        { $$ = $1 * $3;    }
  | exp2 '/' exp2        { $$ = $1 / $3;    }
  | exp1 '/' exp2        { $$ = $1 / $3;    }
  | exp2 '/' exp1        { $$ = $1 / $3;    }
  | exp1 '/' exp1        { $$ = $1 / (float)$3;    }
;

exp3:     TEXTO	{ $$ = $1; }
  | exp3 '+' exp3        {
                          int i = 0;
                          int j = 0;
                          while($1[i]!='\0'){
                            $$[i] = $1[i];
                            i++;
                          }
                          while($3[j]!='\0'){
                            $$[i] = $3[j];
                            i++; j++;
                          }
                          $$[i] = '\0';
                          printf("%s\n", $$);
                          }
  | exp3'('exp3','exp1')'';'{ 
                                int y, j, i = 0;
                                char x[1000];
                                for(j = 0; j < $5; j++){
                                  y = 0; 
                                  while($3[y]!='\0'){
                                    x[i] = $3[y];
                                    y++; i++;
                                  }
                                }
                                x[i] = '\0';
                                printf ("Resultado: %s\n", x);
                                }
;

             
%%

int main() {
  yyparse();
  return 0;
}
             
void yyerror (char *s)
{
  printf ("--%s--\n", s);
}
            
int yywrap()  
{  
  return 1;  
}  
