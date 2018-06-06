#ifndef LIBRERIA
#define LIBRERIA
#include <stdio.h>

union nodo{
    int entero;
    double decimal;
    char* cadena;
};

typedef struct {
    char* key;
    int type;
    union nodo value;
} ht_item;

typedef struct {
    int size;
    int count;
    ht_item** items;
} ht_hash_table;

int strCmp(char * string1, char * string2);

size_t myStrlen(const char * str);

void myMemMove(void *dest, void *src, size_t n);

char *myStrdup(const char * src);

ht_item* ht_new_item(const char* k, const int v, const union nodo r);

void ht_insert(ht_hash_table* ht, const char* key, const int type, const union nodo value);

ht_item *ht_search(ht_hash_table* ht, const char* key);

void ht_delete(ht_hash_table* h, const char* key);

void ht_del_hash_table(ht_hash_table* ht);

ht_hash_table* ht_new();

void ht_print_all(ht_hash_table* ht);

#endif