#!/bin/bash
TEMP_FILE="out.dl"
MAIN_FILE="pass_project.dl"
FUNCTION_TO_SHOW="sanitize"



YELLOW='\033[1;33m'
RED='\033[1;31m'
GREEN='\033[1;32m'
PINK='\033[1;95m'
NC='\033[0m' # No Color

remove_temp_file(){
    if [ -e $TEMP_FILE ]; then
        rm $TEMP_FILE
    fi
}

counterStarter=0
if [ ! -z ${1+x} ]; then 
    counterStarter=$1
fi

counter=0
for entry in `ls test/ | sort -V`;
do
    counter=$((counter+1))
    if (( $counter >= $counterStarter )); then
        path="./test/$entry"
        echo -e "${YELLOW}${entry} ${NC}" 

        remove_temp_file;
        cat  $path  $MAIN_FILE  >> $TEMP_FILE
        vr=`souffle -w $TEMP_FILE | sed -n "/${FUNCTION_TO_SHOW}/,/---------------/p"`
        exp=`grep "expected" $path`

        labelsExpected=$(echo "$exp" |  egrep -o '("l[0-9]+","[a-z]")' | tr  '"' ' ' | tr  ',' ' '| tr '\n' ',' | tr -d '[:space:]')
        labelsExpected2=${labelsExpected%?}

        labelsFound1=$(echo "$vr" |  egrep -o '(l[0-9]+\s+[a-z])')
        labelsFound=$(echo "$vr" |  egrep -o '(l[0-9]+\s+[a-z])'| tr '\n' ',' | tr -d '[:space:]' )
        labelsFound2=${labelsFound%?}

        IFS=',' read -r -a arrayExpected <<< "$labelsExpected2"
        IFS=',' read -r -a arrayFound <<< "$labelsFound2"

        color=$GREEN 
        show=false

        if [[ ${#arrayFound[@]} != ${#arrayExpected[@]} &&  $exp != *"or"* ]]; then
            color=$RED
            echo -e "$labelsFound1\n${color}$exp ${NC}\n"
            continue

        elif [[ ${#arrayFound[@]} != ${#arrayExpected[@]} &&  $exp = *"or"* ]]; then
            color=$PINK
            show=true
        fi
        for element in "${arrayFound[@]}"
        do
            if [[ ! " ${arrayExpected[@]} " =~ "$element" ]]; then
                color=$RED
                echo -e "$labelsFound1\n${color}$exp ${NC}\n"
                break
            fi
        done
        if [[ $show = true && "$color" != "$RED" ]]; then 
            echo -e "$labelsFound1\n${color}$exp ${NC}\n"
        fi
        remove_temp_file;
    fi
done
remove_temp_file;
