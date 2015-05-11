#!/bin/bash

# the offset parameter is designed to aid testing metric. set it to something like 60 to 
# generate data for last month.

offset=$1
if [ -z $1 ];
then
	offset=0
fi

# ./generate_test_data_variable.sh <ds> <days>
# ./generate_test_data_variable.sh 4 14
 
./generate_test_data_variable.sh 4 14 $offset
./generate_test_data_variable.sh 5 14 $offset
./generate_test_data_variable.sh 6 14 $offset
./generate_test_data_variable.sh 8 14 $offset
./generate_test_data_variable.sh 11 14 $offset
./generate_test_data_variable.sh 12 14 $offset
./generate_test_data_variable.sh 20 14 $offset
./generate_test_data_variable.sh 23 14 $offset
./generate_test_data_variable.sh 28 14 $offset
./generate_test_data_variable.sh 33 14 $offset
./generate_test_data_variable.sh 39 14 $offset
./generate_test_data_variable.sh 40 14 $offset
./generate_test_data_variable.sh 44 14 $offset
./generate_test_data_variable.sh 45 14 $offset
./generate_test_data_variable.sh 48 14 $offset
./generate_test_data_variable.sh 49 14 $offset
./generate_test_data_variable.sh 53 14 $offset
./generate_test_data_variable.sh 54 14 $offset
./generate_test_data_variable.sh 55 14 $offset
./generate_test_data_variable.sh 56 14 $offset
./generate_test_data_variable.sh 64 14 $offset
./generate_test_data_variable.sh 65 14 $offset
./generate_test_data_variable.sh 80 14 $offset
./generate_test_data_variable.sh 81 14 $offset
