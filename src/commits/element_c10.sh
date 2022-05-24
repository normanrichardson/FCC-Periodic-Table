#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

# if arguments are given
if [[ $1 ]]
then
  # if the argument is numeric
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # get the element via the atomic number
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
  else
    # get the element from the symbol or the name
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol='$1' or name='$1'")
  fi
  # if an element is found
  if [[ $ELEMENT ]]
  then
    # break down the elements parts
    ATOMIC_NUM=$(echo $ELEMENT | sed -E 's/([0-9]+)\|(.*)\|(.*)/\1/')
    SYMBOL=$(echo $ELEMENT | sed -E 's/([0-9]+)\|(.*)\|(.*)/\2/')
    NAME=$(echo $ELEMENT | sed -E 's/([0-9]+)\|(.*)\|(.*)/\3/')
    
    # get the properties for that atomic number
    PROPERTY=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, types.type FROM properties LEFT JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUM")
    # break down the property into parts
    ATOMIC_MASS=$(echo $PROPERTY | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)/\1/')
    MELTING_POINT=$(echo $PROPERTY | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)/\2/')
    BOILING_POINT=$(echo $PROPERTY | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)/\3/')
    TYPE=$(echo $PROPERTY | sed -E 's/(.*)\|(.*)\|(.*)\|(.*)/\4/')

    echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  else
    echo "I could not find that element in the database."
  fi
else
  echo -e "Please provide an element as an argument."
fi
