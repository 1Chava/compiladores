%{
#include "libreria.h"
#include "ejemplo2.tab.h"
%}
ABC [A-Za-z]+
DIGITO [0-9]
ENTEROPOSITIVO \+{DIGITO}+
ENTERONEGATIVO \-{DIGITO}+
ENTERO {DIGITO}+
REAL {ENTERO}"."{ENTERO}
CADENA \"(\\.|[^"\\])*\"
POTENCIA1 [Pp][Oo][Ww]
INT     [Ii][Nn][Tt]
DOUBLE  [Dd][Oo][Uu][Bb][Ll][Ee]
STRING  [Ss][Tt][Rr][Ii][Nn][Gg]
%%

{POTENCIA1}     {
                printf("POW\n");
                return (POW);
                }

{DOUBLE}        {
                printf("DOUBLE\n");
                return (DOUBLE);
                }

{STRING}        {
                printf("STRING\n");
                return (STRING);
                }

{INT}           {
                printf("INT\n");
                return (INT);
                }

{ABC}           {
                ht_item* valor;
                union nodo r;
                r.cadena = myStrdup(yytext);
                valor = ht_new_item("VARIABLE", 3, r);
                printf("Cadena %s\n", valor->value.cadena);
                yylval.tken = valor;
                return(TOKEN);
                }

"("             {
                printf("Abierto\n");
                return (yytext[0]);
                }

","             {
                printf("Coma\n");
                return (yytext[0]);
                }

")"             {
                printf("Cerrado\n");
                return (yytext[0]);
                }

";"             {
                printf("Punto y coma %c\n", yytext[0]);
                return (yytext[0]);
                }

{CADENA}        {
                ht_item* valor;
                int i = 0;
                while(yytext[i]!='\0')
                        i++;
                myMemMove(&yytext[0], &yytext[1], i);
                int idxToDel = i - 2;
                myMemMove(&yytext[idxToDel], &yytext[idxToDel + 1], i - idxToDel);
                union nodo r;
                r.cadena = myStrdup(yytext);
                valor = ht_new_item("CONSTANTE", 3, r);
                printf("Cadena CONSTANTE %s\n",valor->value.cadena);
                yylval.tken = valor;
                return (TOKEN);
                }

{ENTERO}        {
                ht_item* valor;
                union nodo r;
                r.entero = atoi(yytext);
                valor = ht_new_item("CONSTANTE", 1, r);
		printf("Numero entero %d\n",valor->value.entero);
                yylval.tken = valor;
                return (TOKEN);
                }

{REAL}          {
                ht_item* valor;
                union nodo r;
                r.decimal = atof(yytext);
                valor = ht_new_item("CONSTANTE", 2, r);
		printf("Numero decimal %f\n",valor->value.decimal);
                yylval.tken = valor;
                return (TOKEN);
                }

"+"	 	{
		printf("Signo mas\n");
                return (yytext[0]);
                }

"-"             {
                printf("Signo menos\n");
                return (yytext[0]);
                }

"*"	 	{
		printf("Signo multiplicación\n");
                return (yytext[0]);
                }

"/"             {
                printf("Signo división\n");
                return (yytext[0]);
                }

"="             {
                printf("IGUAL %c\n", yytext[0]);
                return (yytext[0]);
                }

"\n"            {
		printf("Salto de linea\n");
                return (yytext[0]);
                }

.               ;
%%
