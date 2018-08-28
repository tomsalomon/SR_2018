method ml
set p 0
set szr 0
set sv 0
format subjectID trial PairType IsleftGo RESPONSE  TIME
load splitted_fast_dm_*.dat
log splitted_exp_outcome_both_free.txt
