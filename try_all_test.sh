#!/bin/bash

TEMP_FILE="out.dl"
MAIN_FILE="paths.dl"
FUNCTION_TO_SHOW="second_sanitize"



YELLOW='\033[1;33m'
RED='\033[1;31m'
GREEN='\033[1;32m'
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
    vr=`souffle -w $TEMP_FILE | sed -n "/${FUNCTION_TO_SHOW}/,/---------------/p"`
    exp=`grep "expected" $path`

    labelsExpected=$(echo "$exp" |  egrep -o '("l[0-9]+","[a-z]")' | tr  '"' ' ' | tr  ',' ' '| tr '\n' ',' | tr -d '[:space:]')
    labelsExpected2=${labelsExpected%?}

    labelsFound=$(echo "$vr" |  egrep -o '(l[0-9]+\s+[a-z])'| tr '\n' ',' | tr -d '[:space:]' )
    labelsFound2=${labelsFound%?}

    IFS=',' read -r -a arrayExpected <<< "$labelsExpected2"
    IFS=',' read -r -a arrayFound <<< "$labelsFound2"

    color=$GREEN 
    for element in "${arrayFound[@]}"
    do
        if [[ ! " ${arrayExpected[@]} " =~ "$element" ]]; then
            color=$RED
            break
        fi
    done

    echo -e "$vr\n${color}$exp ${NC}\n"


done