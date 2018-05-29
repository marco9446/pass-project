#!/bin/bash

TEMP_FILE="out.dl"
MAIN_FILE="paths.dl"
FUNCTION_TO_SHOW="first_sanitize"



YELLOW='\033[1;33m'
NC='\033[0m' # No Color

remove_temp_file(){
    if [ -e $TEMP_FILE ]; then
        rm $TEMP_FILE
    fi
}

for entry in "./test"/*
do
    echo -e "${YELLOW}${entry} ${NC}" 

    remove_temp_file;
    cat  $entry  $MAIN_FILE  >> $TEMP_FILE
    souffle $TEMP_FILE | sed -n "/${FUNCTION_TO_SHOW}/,/---------------/p" 
    grep "expected" $entry
    remove_temp_file;
    echo ""

done




