#! /bin/bash

declare -r bin="/home/smart/src/bin"
declare -r current="/home/smart/src/test_med"
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

#========================================================
# GENERATOR MAKE_MED
echo "GENERATING make_med ..."
cp base_make_med make_med

## WITH STEM
for method in "${methods[@]}"
do
if [ "$method" = "nnn" ]
  then
    continue
fi
echo "echo \"Create $method versions at \`date\`\"
\$bin/smart convert \$database_stem/spec   proc convert.obj.weight_query \\
                   in query.nnn  out query.$method   query_weight $method
\$bin/smart convert \$database_stem/spec   proc convert.obj.weight_doc \\
                   in doc.nnn  out doc.$method   doc_weight $method
\$bin/smart convert \$database_stem/spec   proc convert.obj.vec_aux  \\
                   in doc.$method  out inv.$method
" >> make_med
done
## WITH NO STEM
for method in "${methods[@]}"
do
if [ "$method" = "nnn" ]
  then
    continue
fi
echo "echo \"Create $method versions at \`date\`\"
\$bin/smart convert \$database_no_stem/spec   proc convert.obj.weight_query \\
                   in query.nnn  out query.$method   query_weight $method
\$bin/smart convert \$database_no_stem/spec   proc convert.obj.weight_doc \\
                   in doc.nnn  out doc.$method   doc_weight $method
\$bin/smart convert \$database_no_stem/spec   proc convert.obj.vec_aux  \\
                   in doc.$method  out inv.$method
" >> make_med
done

echo "Done"
echo ""

#========================================================
# GENERATOR TEST_MED
echo "GENERATING med ..."
cp base_test_med test_med

## WITH STEM
for d_method in "${methods[@]}"
do
for q_method in "${methods[@]}"
do
echo "# $d_method.$q_method experiment
cd $test_stem
cat > spec.$d_method.$q_method << EOF
include_file \$database_stem/spec
query_file query.$q_method
doc_file doc.$d_method
inv_file inv.$d_method
tr_file ./tr.$d_method.$q_method
rr_file ./rr.$d_method.$q_method
run_name \" Doc weight == $d_method; Query weight == $q_method;\"
EOF

\$bin/smart retrieve spec.$d_method.$q_method
echo \"Retrieval run $d_method.$q_method done\"
" >> test_med
done
done


## WITH NO STEM
for d_method in "${methods[@]}"
do
for q_method in "${methods[@]}"
do
echo "# $d_method.$q_method experiment
cd $test_no_stem
cat > spec.$d_method.$q_method << EOF
include_file \$database_no_stem/spec
query_file query.$q_method
doc_file doc.$d_method
inv_file inv.$d_method
tr_file ./tr.$d_method.$q_method
rr_file ./rr.$d_method.$q_method
run_name \" Doc weight == $d_method; Query weight == $q_method;\"
EOF

\$bin/smart retrieve spec.$d_method.$q_method
echo \"Retrieval run $d_method.$q_method done\"
" >> test_med
done
done

echo "Done"
echo ""
