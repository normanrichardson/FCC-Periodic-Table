#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
  else
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol='$1' or name='$1'")
  fi
  ATOMIC_NUM=$(echo $ELEMENT | sed -E 's/([0-9]+)\|(.*)\|(.*)/\1/')
  SYMBOL=$(echo $ELEMENT | sed -E 's/([0-9]+)\|(.*)\|(.*)/\2/')
  NAME=$(echo $ELEMENT | sed -E 's/([0-9]+)\|(.*)\|(.*)/\3/')
else
  echo -e "\nPlease provide an element as an argument."
fi
