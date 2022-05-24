#! /bin/bash
if [ $1 ]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    echo "Number: $1"
  else
    echo "String: $1"
  fi
else
echo -e "\nPlease provide an element as an argument."
fi
