#include <stdio.h>

typedef struct nodo{
    int entero;
    double decimal;
    char* cadena;
}Nodo;

typedef struct tablasimbolos{
    char*   nombre;
    int     tipo;
    Nodo    valor;
}TablaSimbolos;

