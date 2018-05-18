#!/bin/bash

if [ -e ./out.dl ]; then
    rm out.dl
fi

a="./test/test"
c=".txt"
d=$a$1$c

YELLOW='\033[1;33m'
NC='\033[0m' # No Color
line=`wc -l $d | grep -oE '^\s*[0-9]+'`
echo -e "${YELLOW}Error line offset: ${line} ${NC}\n" 

cat $d "paths.dl" >> out.dl
souffle out.dl
rm out.dl
echo
echo
grep "//" $d

