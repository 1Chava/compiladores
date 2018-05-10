abc [A-Za-z]
digito [0-9]
variable ({abc}|_)({abc}|{digito}|_)*
enteropositivo {digito}+
enteronegativo -{digito}+
entero {enteropositivo}|{enteronegativo}
real {entero}("."{enteropositivo})*
potencia pow"("{real},{entero}");"
suma {real}"+"{real}
resta {real}"-"{real}
multiplicacion {real}"*"{real}
division {real}"/"{real}
modulo  MOD"("{entero},{entero}");"
raiz [Rr][Aa][Ii][Zz]"("{enteropositivo},{enteropositivo}")";
raizIm [Rr][Aa][Ii][Zz]"("{enteronegativo},{enteropositivo}")";
%%
{potencia} {printf("Potencia");}
{variable} {printf("Nombre de Variable");}
{entero} {printf("Entero");}
{real} {printf("Real");}
{suma} {printf("Suma");}
{resta} {printf("Resta");}
{multiplicacion} {printf("Multiplicacion");}
{division} {printf("Division");}
{modulo} {printf("Modulo");}
{raiz} {printf("Raiz");}
{raizIm} {printf("Raiz Imaginaria");}
%%
