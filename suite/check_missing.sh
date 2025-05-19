#!/bin/bash
for dir in $(find ./ -type d) 
do
  if [ $dir = "./" ]; then
    continue
  fi 
  if [ !  $(find $dir -name "*.ml") ] ; then
    echo "Missing OCaml $dir"
  fi 
  if [ !  $(find $dir -name "*.mlb") ] ; then 
    echo "Missing MLton $dir"
  fi
  if [ !  $(find $dir -name "*.cm") ] ; then 
    echo "Missing Sml/NJ $dir"
  fi
  if [ !  $(find $dir -name "*.rs") ] ; then 
    echo "Missing Rust $dir"
  fi
  if [ !  $(find $dir -name "*.sc") ] ; then 
    echo "Missing Compiling-Sc $dir"
  fi
  if [ !  $(find $dir -name "*.effekt") ] ; then 
    echo "Missing Effekt $dir"
  fi


done
