#!/bin/bash

TEMP_FILE="out.dl"
MAIN_FILE="paths.dl"
FUNCTION_TO_SHOW="second_sanitize"



YELLOW='\033[1;33m'
NC='\033[0m' # No Color

remove_temp_file(){
    if [ -e $TEMP_FILE ]; then
        rm $TEMP_FILE
    fi
}

for entry in `ls test/ | sort -V`;
do
    path="./test/$entry"
    echo -e "${YELLOW}${entry} ${NC}" 

    remove_temp_file;
    cat  $path  $MAIN_FILE  >> $TEMP_FILE
    souffle $TEMP_FILE | sed -n "/${FUNCTION_TO_SHOW}/,/---------------/p" 
    grep "expected" $path
    remove_temp_file;
    echo ""

done




