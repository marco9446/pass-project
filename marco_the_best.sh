#!/bin/bash



a="./test/test"
b= $2
c=".txt"
d=$a$b$c
cat $d "the_greatest_datalog_program_ever.dl" >> prov.dl
souffle prov.dl
rm prov.dl
