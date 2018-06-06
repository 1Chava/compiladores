#!/usr/bin/env bash

flex ejemplo2.l
bison ejemplo2.y -d
gcc -lm ejemplo2.tab.c libreria.c lex.yy.c -o variable
./variable