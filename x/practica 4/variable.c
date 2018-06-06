#include <stdio.h>
#include "libreria.h"
#define ENTERO 1
#define DECIMAL 2
#define CADENA 3

int main() {
    union nodo r;
    r.entero = 5;
    printf("Inicio\n");
    ht_hash_table* ht = ht_new();
    printf("Creado\n");
    ht_insert(ht , "var1", 1, r);
    printf("Insertado\n");
    ht_item *valor = ht_search(ht, "var1");
    if(valor != NULL){
        if(valor->type == ENTERO) {
            printf("Valor de %s es entero: %d\n", valor->key, valor->value.entero);
        }else if(valor->type == DECIMAL) {
            printf("Valor de %s es decimal: %f\n", valor->key, valor->value.decimal);
        }else {
            printf("Valor de %s es cadena: %s\n", valor->key, valor->value.cadena);
        }
    }
    ht_print_all(ht);
    ht_delete(ht, "var1");
    printf("Borrado\n");
    ht_print_all(ht);
    ht_del_hash_table(ht);
}

// typedef struct nodo{
//     int entero;
//     double decimal;
//     char* cadena;
// }Nodo;

// typedef struct tablasimbolos{
//     char*   nombre;
//     int     tipo;
//     Nodo    valor;
// }TablaSimbolos;

