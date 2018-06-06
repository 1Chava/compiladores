#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "libreria.h"
#define ENTERO 1
#define DECIMAL 2
#define CADENA 3

static ht_item HT_DELETED_ITEM = {NULL, NULL};
static const int HT_PRIME_1 = 61;
static const int HT_PRIME_2 = 67;

int strCmp(char * string1, char * string2 ) {
    for (int i = 0; ; i++) {
        if (string1[i] != string2[i])
            return string1[i] < string2[i] ? -1 : 1;
        if (string1[i] == '\0')
            return 0;
    }
}

size_t myStrlen(const char * str){
    const char *s;
    for (s = str; *s; ++s) {}
    return(s - str);
}

char *myStrdup(const char * src) {
    char *str, *p;
    int len = 0;

    while (src[len])
        len++;
    str = malloc(len + 1);
    p = str;
    while (*src)
        *p++ = *src++;
    *p = '\0';
    return str;
}

void myMemMove(void *dest, void *src, size_t n) {
    char *csrc = (char *)src;
    char *cdest = (char *)dest;
    char *temp[n];
    
    for (int i=0; i<n; i++)
        temp[i] = csrc[i];
        
    for (int i=0; i<n; i++)
        cdest[i] = temp[i];       
}

ht_item* ht_new_item(const char* k, const int v, const union nodo r) {
    ht_item* i = malloc(sizeof(ht_item));
    i->key = myStrdup(k);
    i->type = v;
    i->value = r;
    return i;
}

ht_hash_table* ht_new() {
    ht_hash_table* ht = malloc(sizeof(ht_hash_table));
    ht->size = 53;
    ht->count = 0;
    ht->items = calloc((size_t)ht->size, sizeof(ht_item*));
    return ht;
}

static void ht_del_item(ht_item* i) {
    free(i->key);
    free(i);
}

void ht_del_hash_table(ht_hash_table* ht) {
    for (int i = 0; i < ht->size; i++) {
        ht_item* item = ht->items[i];
        if (item != NULL && item != &HT_DELETED_ITEM) {
            ht_del_item(item);
        }
    }
    free(ht->items);
    free(ht);
}

static int ht_hash(const char* s, const int a, const int m) {
    long hash = 0;
    const int len_s = myStrlen(s);
    for (int i = 0; i < len_s; i++) {
        hash += (long)pow(a, len_s - (i+1)) * s[i];
        hash = hash % m;
    }
    return (int)hash;
}

static int ht_get_hash(const char* s, const int num_buckets, const int attempt) {
    const int hash_a = ht_hash(s, HT_PRIME_1, num_buckets);
    const int hash_b = ht_hash(s, HT_PRIME_2, num_buckets);
    return (hash_a + (attempt * (hash_b + 1))) % num_buckets;
}

void ht_insert(ht_hash_table* ht, const char* key, const int type, const union nodo value) {
    ht_item* item = ht_new_item(key, type, value);
    int index = ht_get_hash(item->key, ht->size, 0);
    ht_item* cur_item = ht->items[index];
    int i = 1;
    while (cur_item != NULL) {
        if (cur_item != &HT_DELETED_ITEM) {
            if (strCmp(cur_item->key, key) == 0) {
                ht_del_item(cur_item);
                ht->items[index] = item;
                return;
            }
        }
        index = ht_get_hash(item->key, ht->size, i);
        cur_item = ht->items[index];
        i++;
    } 
    ht->items[index] = item;
    ht->count++;
}

ht_item* ht_search(ht_hash_table* ht, const char* key) {
    int index = ht_get_hash(key, ht->size, 0);
    ht_item* item = ht->items[index];
    int i = 1;
    while (item != NULL) {
        if (item != &HT_DELETED_ITEM) { 
            if (strCmp(item->key, key) == 0) {
                return item;
            }
        }
        index = ht_get_hash(key, ht->size, i);
        item = ht->items[index];
        i++;
    }
    return NULL;
}

void ht_delete(ht_hash_table* ht, const char* key) {
    int index = ht_get_hash(key, ht->size, 0);
    ht_item* item = ht->items[index];
    int i = 1;
    while (item != NULL) {
        if (item != &HT_DELETED_ITEM) {
            if (strCmp(item->key, key) == 0) {
                ht_del_item(item);
                ht->items[index] = &HT_DELETED_ITEM;
            }
        }
        index = ht_get_hash(key, ht->size, i);
        item = ht->items[index];
        i++;
    } 
    ht->count--;
}

void ht_print_all(ht_hash_table* ht){
    int len = 0, i = 0;
    ht_item* item;
    printf("Nombre | Tipo | Valor\n");
    while(len < ht->count){
        item = ht->items[i];
        if(item != NULL) {
            if (item != &HT_DELETED_ITEM){
                if(item->type == ENTERO){
                    printf("%s | Entero | %d\n", item->key, item->value.entero);
                }
                else if(item->type == DECIMAL){
                    printf("%s | Decimal | %f\n", item->key, item->value.decimal);
                }else{
                    printf("%s | Cadena | %s\n", item->key, item->value.cadena);
                }
            }
            len++;
        }
        i++;
    }
}