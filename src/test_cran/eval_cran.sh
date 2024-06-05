#! /bin/bash

declare -r bin="/home/smart/src/bin"
declare -r current="/home/smart/src/test_cran"
declare -r database="$current/indexed"
declare -r database_stem="$database/with_stem"
declare -r database_no_stem="$database/with_no_stem"

declare -r test="$current/test"
declare -r test_stem="$test/with_stem"
declare -r test_no_stem="$test/with_no_stem"

declare  -a methods=(
  "nnn" "ntn" "nnc" "ntc" 
  "bnn" "btn" "bnc" "btc" 
  "ann" "atn" "anc" "atc"
  "lnn" "ltn" "lnc" "ltc"
)

./test_cran

echo "Experiment 1 : WITH STEM"
cd $test_stem

for d_method in "${methods[@]}"
do
for q_method in "${methods[@]}"
do
echo "METHOD $d_method.$q_method


$(tcsh ../../../bin/smprint rr_eval spec.$d_method.$q_method \
  | tail -n 23 \
  | sed '/5 docs/d' \
  | sed '/10 docs/d' \
  | sed '/30 docs/d' \
  | sed '/^$/d'
)

----------------------------------------" >> result
done
done

echo "Experiment 1 is completed"

echo ""

echo "Experiment 2 : WITHOUT STEM"
cd $test_no_stem

for d_method in "${methods[@]}"
do
for q_method in "${methods[@]}"
do
echo "METHOD $d_method.$q_method


$(tcsh ../../../bin/smprint rr_eval spec.$d_method.$q_method \
  | tail -n 23 \
  | sed '/5 docs/d' \
  | sed '/10 docs/d' \
  | sed '/30 docs/d' \
  | sed '/^$/d'
)

----------------------------------------" >> result
done
done

echo "Experiment 2 is completed"