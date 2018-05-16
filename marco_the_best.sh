#!/bin/bash


rm prov.dl
a="./test/test"
c=".txt"
d=$a$1$c
cat $d "the_greatest_datalog_program_ever.dl" >> prov.dl
souffle prov.dl
