#!/bin/bash


rm prov.dl
a="./test/test"
c=".txt"
d=$a$1$c

offest=(wc -l $d)
echo "offset:" $offset

cat $d "final.dl" >> prov.dl
souffle prov.dl
rm prov.dl
echo
echo
grep "//" $d

