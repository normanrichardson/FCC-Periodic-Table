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
  
  PROPERTY=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM properties LEFT JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUM")
  ATOMIC_MASS=$(echo $PROPERTY | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)/\1/')
  MELTING_POINT=$(echo $PROPERTY | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)/\2/')
  BOILING_POINT=$(echo $PROPERTY | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)/\3/')
  TYPE=$(echo $PROPERTY | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)/\4/')

  echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
else
  echo -e "\nPlease provide an element as an argument."
fi
