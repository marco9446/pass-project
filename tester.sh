#!/bin/bash

if [ -e ./out.dl ]; then
    rm out.dl
fi


cat $1 "pass_project.dl" >> out.dl
souffle -w out.dl
rm out.dl
echo


