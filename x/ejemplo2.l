%{
#include "ejemplo2.tab.h"
%}
ABC [A-Za-z]+
DIGITO [0-9]
ENTEROPOSITIVO \+{DIGITO}+
ENTERONEGATIVO \-{DIGITO}+
ENTERO {DIGITO}+|{ENTEROPOSITIVO}|{ENTERONEGATIVO}
REAL {ENTERO}"."{ENTERO}
CADENA \"{ABC}\"
POTENCIA1 [Pp][Oo][Ww]
%%

{POTENCIA1}     {
                printf("cadena %s\n", yytext);
                yylval.texto = yytext;
                return (TEXTO);
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
                printf("Punto y coma\n");
                return (yytext[0]);
                }

{CADENA}        {
                printf("%s\n", yytext);
                int i = 0;
                while(yytext[i]!='\0')
                        i++;
                myMemMove(&yytext[0], &yytext[1], i);
                int idxToDel = i - 2;
                myMemMove(&yytext[idxToDel], &yytext[idxToDel + 1], i - idxToDel);
                yylval.texto = yytext;
                return (TEXTO);
                }

{ENTERO}        {
		printf("Numero entero %s\n",yytext);
                yylval.entero = atoi(yytext);
                return (ENTERO);
                }

{REAL}        {
		printf("Numero decimal %s\n",yytext);
                yylval.decimal = atof(yytext);
                return (DECIMAL);
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

"\n"            {
		printf("Salto de linea\n");
                return (yytext[0]);
                }

.               ;
%%
