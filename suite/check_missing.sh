#!/bin/bash
for dir in $(find ./ -type d) 
do
  if [ $dir = "./" ]; then
    continue
  fi 
  if [ !  $(find $dir -name "*.ml") ] ; then
    echo $dir
  fi
done
