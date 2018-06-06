%{
#include "libreria.h"
//#include <math.h>
int yylex(void);
void yyerror (char *);
ht_hash_table* ht;
ht_item* valor;
ht_item* v1;
ht_item* v2;
%}
             
/* Declaraciones de BISON */
%union{
	int     entero;
  char    *texto;
  float    decimal;
  ht_item* tken;
}

%token <entero> ENTERO
%token <texto> TEXTO
%token <decimal> DECIMAL
%token <tken> TOKEN
%token INT
%token DOUBLE
%token STRING
%token POW
%type <entero> exp1
%type <decimal> exp2
%type <tken> exp3
%type <tken> exp4

%left '+''-'
%left '*''/'
%left '('')'';''='         
/* Gramática */
%%
             
input:    /* cadena vacía */
        | input line         
;

line:     '\n'
        | exp1 '\n'  {  printf ("\tresultado: %d\n", $1); }
        | exp2 '\n'  {  printf ("\tresultado: %.2f\n", $1); }
        | exp3';' '\n'  { if($1 != NULL){
                            if(valor != NULL){
                              if(valor->type == 1) {
                                printf("Valor de %s es entero: %d\n", valor->key, valor->value.entero);
                              }else if(valor->type == 2) {
                                printf("Valor de %s es decimal: %f\n", valor->key, valor->value.decimal);
                              }else {
                                printf("Valor de %s es cadena: %s\n", valor->key, valor->value.cadena);
                              }
                            } else{
                              printf("El valor no se encuentra \n"); 
                            }
                          }
                        }
        | exp4';' '\n'  { if(valor != NULL){
                            if(valor->type == 1) {
                              printf("Valor de %s es entero: %d\n", valor->key, valor->value.entero);
                            }else if(valor->type == 2) {
                              printf("Valor de %s es decimal: %f\n", valor->key, valor->value.decimal);
                            }else {
                              printf("Valor de %s es cadena: %s\n", valor->key, valor->value.cadena);
                            }
                          } else{
                            printf("El valor no se encuentra \n"); 
                          }
                        }
;
             
exp1:     ENTERO	{ $$ = $1; }
	| exp1 '+' exp1        { $$ = $1 + $3;    }
	| exp1 '-' exp1        { $$ = $1 - $3;    }
  | exp1 '*' exp1        { $$ = $1 * $3;    }
  | INT exp3 '=' exp1';' { union nodo r;
                           r.entero = $4;
                           ht_insert(ht , $2, 1, r);
                           $$ = $4;}
;

exp2:     DECIMAL	          { $$ = $1; }
	| exp2 '+' exp2           { $$ = $1 + $3;    }
  | exp1 '+' exp2           { $$ = $1 + $3;    }
  | exp2 '+' exp1           { $$ = $1 + $3;    }
	| exp2 '-' exp2           { $$ = $1 - $3;    }
  | exp1 '-' exp2           { $$ = $1 - $3;    }
  | exp2 '-' exp1           { $$ = $1 - $3;    }
  | exp2 '*' exp2           { $$ = $1 * $3;    }
  | exp1 '*' exp2           { $$ = $1 * $3;    }
  | exp2 '*' exp1           { $$ = $1 * $3;    }
  | exp2 '/' exp2           { $$ = $1 / $3;    }
  | exp1 '/' exp2           { $$ = $1 / $3;    }
  | exp2 '/' exp1           { $$ = $1 / $3;    }
  | exp1 '/' exp1           { $$ = $1 / (float)$3;    }
  | DOUBLE exp3 '=' exp2';' { union nodo r;
                              r.decimal = $4;
                              ht_insert(ht , $2, 2, r);
                              $$ = $4;
                            }
;

exp3: TOKEN             { 
        $$ = $1; 
      }
    | INT exp3  {
        v1 = ht_search(ht, $2->value.cadena);
        if(v1 != NULL){
          printf("LA VARIABLE YA ESTA OCUPADA\n");
          $$ = $2;
        } else {
          printf("hola\n");
          union nodo r;
          r.entero = NULL;
          valor = ht_new_item($2->value.cadena, 1, r);
          ht_insert(ht , valor->key, valor->type, valor->value);
          $$ = valor;
          ht_print_all(ht);
        }
    }
    | INT exp3 '=' exp4 { 
        printf("\t\t\tASIGNACION ENTERO\n");
        v1 = ht_search(ht, $2->value.cadena);
        if(v1 != NULL){
          printf("LA VARIABLE YA ESTA OCUPADA\n");
          $$ = $2;
        } else if($4 == NULL) {
          printf("Hubo un problema con el tipo de variable, debe ser de tipo int\n ");
          $$ = NULL;
        } else {
          if(strCmp("VARIABLE", $4->key) == 0){
            v2 = ht_search(ht, $4->value.cadena);
          }else{
            v2 = $4;
          }
          union nodo r;
          if(v2->type == 1){
            r.entero = v2->value.entero;
            valor = ht_new_item($2->value.cadena, 1, r);
            ht_insert(ht , valor->key, valor->type, valor->value);
            $$ = valor;
          } else if(v2->type == 2) {
            r.entero = v2->value.decimal;
            valor = ht_new_item($2->value.cadena, 1, r);
            ht_insert(ht , valor->key, valor->type, valor->value);
            $$ = valor;
          } else {
            printf("Hubo un problema con el tipo de variable, debe ser de tipo int\n ");
            $$ = NULL;
          }
        }
        ht_print_all(ht);
      } 
    | DOUBLE exp3 '=' exp4  { 
        printf("\t\t\tASIGNACION DECIMAL\n");
        v1 = ht_search(ht, $2->value.cadena);
        if(v1 != NULL){
          printf("LA VARIABLE YA ESTA OCUPADA\n");
          $$ = v1;
        } else if($4 == NULL) {
          printf("Hubo un problema con el tipo de variable, debe ser de tipo decimal\n ");
          $$ = NULL;
        } else {
          if(strCmp("VARIABLE", $4->key) == 0) {
            v2 = ht_search(ht, $4->value.cadena);
          }else {
            v2 = $4;
          }
          union nodo r;
          if(v2->type == 1) {
            r.decimal = v2->value.entero;
            valor = ht_new_item($2->value.cadena, 2, r);
            ht_insert(ht , valor->key, valor->type, valor->value);
            $$ = valor;
          } else if(v2->type == 2) {
            r.decimal = v2->value.decimal;
            valor = ht_new_item($2->value.cadena, 2, r);
            ht_insert(ht , valor->key, valor->type, valor->value);
            $$ = valor;
          } else{
            printf("Hubo un problema con el tipo de variable, debe ser de tipo decimal\n ");
            $$ = NULL;
          }
        }
        ht_print_all(ht);
      } 
    | STRING exp3 '=' exp4  { 
        printf("\t\t\tASIGNACION CADENA\n");
        v1 = ht_search(ht, $2->value.cadena);
        if(v1 != NULL){
          printf("LA VARIABLE YA ESTA OCUPADA\n");
          $$ = v1;
        } else if($4 == NULL) {
          printf("Hubo un problema con el tipo de variable, debe ser de tipo decimal\n ");
          $$ = NULL;
        } else {
          if(strCmp("VARIABLE", $4->key) == 0) {
            v2 = ht_search(ht, $4->value.cadena);
          } else {
            v2 = $4;
          }
          if(v2->type == 3){
            union nodo r;
            r.cadena = v2->value.cadena;
            valor = ht_new_item($2->value.cadena, 3, r);
            ht_insert(ht , valor->key, valor->type, valor->value);
            $$ = valor;
          } else {
            printf("Hubo un problema con el tipo de variable, debe ser de tipo string\n ");
            $$ = NULL;
          }
        }
        ht_print_all(ht);
      }
    | exp3 '=' exp4 { 
        printf("\t\t\tASIGNACION\n");
        v1 = ht_search(ht, $1->value.cadena);
        if(strCmp("VARIABLE", $3->key) == 0){
          v2 = ht_search(ht, $3->value.cadena);
        } else {
          v2 = $3;
        }
        if(v1 == NULL) {
          printf("\tLA VARIABLE NO EXISTE\n");
          $$ = v1;
        } else if(v2 != NULL) {
          if(v1->type == 3){
            if(v2->type == 3){
              v1->value.cadena = v2->value.cadena;
              ht_insert(ht , v1->key, v1->type, v1->value);
              $$ = v1;
            }else{
              printf("Hubo un problema con el tipo de variable, debe ser de tipo string\n ");
              $$ = NULL;
            }
          } else if( v1->type == 2 ) {
            if(v2->type == 2){
              v1->value.decimal = v2->value.decimal;
              ht_insert(ht , v1->key, v1->type, v1->value);
              $$ = v1;
            }else if(v2->type == 1){
              v1->value.decimal = v2->value.entero;
              ht_insert(ht , v1->key, v1->type, v1->value);
              $$ = v1;
            } else {
              printf("Hubo un problema con el tipo de variable, debe ser de tipo decimal\n ");
              $$ = NULL;
            }
          } else {
            if(v2->type == 1){
              v1->value.entero = v2->value.entero;
              ht_insert(ht , v1->key, v1->type, v1->value);
              $$ = v1;
            }else if(v2->type == 2){
              v1->value.entero = v2->value.decimal;
              ht_insert(ht , v1->key, v1->type, v1->value);
              $$ = v1;
            }else{
              printf("Hubo un problema con el tipo de variable, debe ser de tipo entero\n ");
              $$ = NULL;
            }
          }
        } else {
          printf("\tHubo un problema en la asignación\n");
          $$ = NULL;
        }
        ht_print_all(ht);
      } 
;

exp4: TOKEN                   { $$ = $1; } 
    | exp4 '+' exp4            { printf("\t\t\tSUMA\n");
                                if(strCmp("VARIABLE", $1->key) == 0){
                                      v1 = ht_search(ht, $1->value.cadena);
                                }else{
                                      v1 = $1;
                                }
                                if(strCmp("VARIABLE", $3->key) == 0){
                                      v2 = ht_search(ht, $3->value.cadena);
                                }else{
                                      v2 = $3;
                                }
                                if(v1 != NULL && v2 != NULL){
                                  if(v1->type == 3 && v2->type == 3){
                                    int i = 0;
                                    int j = 0;
                                    char x[1000];
                                    while(v1->value.cadena[i]!='\0'){
                                      x[i] = v1->value.cadena[i];
                                      i++;  }
                                    while(v2->value.cadena[j]!='\0'){
                                      x[i] = v2->value.cadena[j];
                                      i++; j++; }
                                    x[i] = '\0';
                                    union nodo r;
                                    r.cadena = x;
                                    valor = ht_new_item("RESULTADO", 3, r);
                                    printf("\tResultado: %s\n", valor->value.cadena);
                                  } else if(v1->type == 2 && v2->type == 2){
                                    union nodo r;
                                    r.decimal = v1->value.decimal + v2->value.decimal;
                                    valor = ht_new_item("RESULTADO", 2, r);
                                    printf("\tResultado: %f\n", valor->value.decimal);
                                  } else if(v1->type == 2 && v2->type == 1){
                                    union nodo r;
                                    r.decimal = v1->value.decimal + v2->value.entero;
                                    valor = ht_new_item("RESULTADO", 2, r);
                                    printf("\tResultado: %f\n", valor->value.decimal);
                                  } else if(v1->type == 1 && v2->type == 2){
                                    union nodo r;
                                    r.decimal = v1->value.entero + v2->value.decimal;
                                    valor = ht_new_item("RESULTADO", 2, r);
                                    printf("\tResultado: %f\n", valor->value.decimal);
                                  } else if(v1->type == 1 && v2->type == 1){
                                    union nodo r;
                                    r.entero = v1->value.entero + v2->value.entero;
                                    valor = ht_new_item("RESULTADO", 1, r);
                                    printf("\tResultado: %d\n", valor->value.entero);
                                  }else{
                                    printf("\tDatos incompatibles %d + %d\n", v1->type, v2->type);
                                    valor = NULL;
                                  }
                                  $$ = valor; 
                                }else{
                                  printf("\tHubo un problema en la asignación\n");
                                  $$ = NULL;
                                }
                                ht_print_all(ht);
                              }
    | exp4 '-' exp4            { printf("\t\t\tRESTA\n");
                                if(strCmp("VARIABLE", $1->key) == 0){
                                      v1 = ht_search(ht, $1->value.cadena);
                                }else{
                                      v1 = $1;
                                }
                                if(strCmp("VARIABLE", $3->key) == 0){
                                      v2 = ht_search(ht, $3->value.cadena);
                                }else{
                                      v2 = $3;
                                }
                                if(v1 != NULL && v2 != NULL){
                                  if(v1->type == 3 && v2->type == 3){
                                    int i = 0;
                                    int j = 0;
                                    int k = 0;
                                    int q;
                                    char x[1000];
                                    char *y = myStrdup(v1->value.cadena);
                                    char *z = myStrdup(v2->value.cadena);
                                    while(y[i]!='\0'){
                                      j = 0; q = 0;
                                      while(z[j]!='\0'){
                                        if(y[i] == z[j]){
                                          q = 1;
                                          break;
                                        }
                                        j++;
                                      }
                                      if(!q){
                                        x[k++] = y[i];                                                                                
                                      }else{
                                        int l = 0;
                                        while(z[l]!='\0')
                                          l++;
                                        myMemMove(&z[j], &z[j + 1], l - j);
                                      }
                                      i++;
                                    }
                                    x[k] = '\0';
                                    union nodo r;
                                    r.cadena = x;
                                    valor = ht_new_item("RESULTADO", 3, r);
                                    printf("\tResultado: %s\n", valor->value.cadena);
                                  } else if(v1->type == 2 && v2->type == 2){
                                    union nodo r;
                                    r.decimal = v1->value.decimal - v2->value.decimal;
                                    valor = ht_new_item("RESULTADO", 2, r);
                                    printf("\tResultado: %f\n", valor->value.decimal);
                                  } else if(v1->type == 2 && v2->type == 1){
                                    union nodo r;
                                    r.decimal = v1->value.decimal - v2->value.entero;
                                    valor = ht_new_item("RESULTADO", 2, r);
                                    printf("\tResultado: %f\n", valor->value.decimal);
                                  } else if(v1->type == 1 && v2->type == 2){
                                    union nodo r;
                                    r.decimal = v1->value.entero - v2->value.decimal;
                                    valor = ht_new_item("RESULTADO", 2, r);
                                    printf("\tResultado: %f\n", valor->value.decimal);
                                  } else if(v1->type == 1 && v2->type == 1){
                                    union nodo r;
                                    r.entero = v1->value.entero - v2->value.entero;
                                    valor = ht_new_item("RESULTADO", 1, r);
                                    printf("\tResultado: %d\n", valor->value.entero);
                                  } else{
                                    printf("\tDatos incompatibles %d + %d\n", v1->type, v2->type);
                                    valor = NULL;
                                  }
                                  $$ = valor; 
                                }else{
                                  printf("\tHubo un problema en la asignación\n");
                                  $$ = NULL;
                                }
                                ht_print_all(ht);
                              }
    | exp4 '*' exp4           { printf("\t\t\tSUMA\n");
                                if(strCmp("VARIABLE", $1->key) == 0){
                                      v1 = ht_search(ht, $1->value.cadena);
                                }else{
                                      v1 = $1;
                                }
                                if(strCmp("VARIABLE", $3->key) == 0){
                                      v2 = ht_search(ht, $3->value.cadena);
                                }else{
                                      v2 = $3;
                                }
                                if(v1 != NULL && v2 != NULL){
                                  if((v1->type == 3 && v2->type == 1) || (v1->type == 1 && v2->type == 3)){
                                    int w, y, j, i = 0;
                                    char x[1000], *s;
                                    if(v1->type == 3){
                                      s = myStrdup(v1->value.cadena);
                                      w = v2->value.entero;
                                    }else{
                                      s = myStrdup(v2->value.cadena);
                                      w = v1->value.entero;
                                    }
                                    for(j = 0; j < w; j++){
                                      y = 0; 
                                      while(s[y]!='\0'){
                                        x[i] = s[y];
                                        y++; i++;
                                      }
                                    }
                                    x[i] = '\0';
                                    union nodo r;
                                    r.cadena = x;
                                    valor = ht_new_item("RESULTADO", 3, r);
                                    printf ("\tResultado: %s\n", valor->value.cadena);
                                    $$ = valor;
                                  } else if(v1->type == 2 && v2->type == 2){
                                    union nodo r;
                                    r.decimal = v1->value.decimal * v2->value.decimal;
                                    valor = ht_new_item("RESULTADO", 2, r);
                                    printf("\tResultado: %f\n", valor->value.decimal);
                                  } else if(v1->type == 2 && v2->type == 1){
                                    union nodo r;
                                    r.decimal = v1->value.decimal * v2->value.entero;
                                    valor = ht_new_item("RESULTADO", 2, r);
                                    printf("\tResultado: %f\n", valor->value.decimal);
                                  } else if(v1->type == 1 && v2->type == 2){
                                    union nodo r;
                                    r.decimal = v1->value.entero * v2->value.decimal;
                                    valor = ht_new_item("RESULTADO", 2, r);
                                    printf("\tResultado: %f\n", valor->value.decimal);
                                  } else if(v1->type == 1 && v2->type == 1){
                                    union nodo r;
                                    r.entero = v1->value.entero * v2->value.entero;
                                    valor = ht_new_item("RESULTADO", 1, r);
                                    printf("\tResultado: %d\n", valor->value.entero);
                                  } else{
                                    printf("\tDatos incompatibles %d + %d\n", v1->type, v2->type);
                                    valor = NULL;
                                  }
                                  $$ = valor; 
                                }else{
                                  printf("\tHubo un problema en la asignación\n");
                                  $$ = NULL;
                                }
                                ht_print_all(ht);
                              }
    | exp4 '/' exp4           { printf("\t\t\tDIVISION\n");
                                if(strCmp("VARIABLE", $1->key) == 0){
                                      v1 = ht_search(ht, $1->value.cadena);
                                }else{
                                      v1 = $1;
                                }
                                if(strCmp("VARIABLE", $3->key) == 0){
                                      v2 = ht_search(ht, $3->value.cadena);
                                }else{
                                      v2 = $3;
                                }
                                if(v1 != NULL && v2 != NULL){
                                  if(v1->type == 3 && v2->type == 1){
                                    int i = 0;
                                    int j = 0;
                                    int k = 0;
                                    int q;
                                    char x[1000];
                                    char *y = myStrdup(v1->value.cadena);
                                    char *z = myStrdup(v2->value.cadena);
                                    while(y[i]!='\0'){
                                      j = 0; q = 0;
                                      while(z[j]!='\0'){
                                        if(y[i] == z[j]){
                                          q = 1;
                                          break;
                                        }
                                        j++;
                                      }
                                      if(!q)
                                        x[k++] = y[i];                                                                                
                                      i++;
                                    }
                                    x[k] = '\0';
                                    union nodo r;
                                    r.cadena = x;
                                    valor = ht_new_item("RESULTADO", 3, r);
                                    printf("\tResultado: %s\n", valor->value.cadena);
                                  } else if(v1->type == 2 && v2->type == 2){
                                    union nodo r;
                                    r.decimal = v1->value.decimal / v2->value.decimal;
                                    valor = ht_new_item("RESULTADO", 2, r);
                                    printf("\tResultado: %f\n", valor->value.decimal);
                                  } else if(v1->type == 2 && v2->type == 1){
                                    union nodo r;
                                    r.decimal = v1->value.decimal / v2->value.entero;
                                    valor = ht_new_item("RESULTADO", 2, r);
                                    printf("\tResultado: %f\n", valor->value.decimal);
                                  } else if(v1->type == 1 && v2->type == 2){
                                    union nodo r;
                                    r.decimal = v1->value.entero / v2->value.decimal;
                                    valor = ht_new_item("RESULTADO", 2, r);
                                    printf("\tResultado: %f\n", valor->value.decimal);
                                  } else if(v1->type == 1 && v2->type == 1){
                                    union nodo r;
                                    r.decimal = v1->value.entero / (float)v2->value.entero;
                                    valor = ht_new_item("RESULTADO", 2, r);
                                    printf("\tResultado: %f\n", valor->value.decimal);
                                  } else{
                                    printf("\tDatos incompatibles %d + %d\n", v1->type, v2->type);
                                    valor = NULL;
                                  }
                                  $$ = valor; 
                                }else{
                                  printf("\tHubo un problema en la asignación\n");
                                  $$ = NULL;
                                }
                                ht_print_all(ht);
                              }
    | POW'('exp4','exp4')'    { printf("\t\t\tPOTENCIA\n");
                                if(strCmp("VARIABLE", $3->key) == 0){
                                      v1 = ht_search(ht, $3->value.cadena);
                                }else{
                                      v1 = $3;
                                }
                                if(strCmp("VARIABLE", $5->key) == 0){
                                      v2 = ht_search(ht, $5->value.cadena);
                                }else{
                                      v2 = $5;
                                }
                                if(v1 != NULL && v2 != NULL){
                                  int y, j, i = 0;
                                  char x[1000];
                                  for(j = 0; j < v2->value.entero; j++){
                                    y = 0; 
                                    while(v1->value.cadena[y]!='\0'){
                                      x[i] = v1->value.cadena[y];
                                      y++; i++;
                                    }
                                  }
                                  x[i] = '\0';
                                  union nodo r;
                                  r.cadena = x;
                                  valor = ht_new_item("RESULTADO", 3, r);
                                  printf ("\tResultado: %s\n", valor->value.cadena);
                                  $$ = valor;
                                }else{
                                  printf("\tHubo un problema en la potencia\n");
                                  $$ = NULL;
                                }
                                ht_print_all(ht);
                              }
;
             
%%

int main() {
  ht = ht_new();
  yyparse();
  return 0;
}



void yyerror (char *s)
{
  printf ("--%s--\n", s);
  yyparse();
}
            
int yywrap()  
{  
  return 1;  
}  
