#!/bin/bash

echo "insert file name"
read filename

cp $filename init_rom.mem
num=`wc -l $filename | egrep -o '[0-9]*'`   

for ((i=num;i<1024;i++));do

echo " 00000000" >> init_rom.mem

done