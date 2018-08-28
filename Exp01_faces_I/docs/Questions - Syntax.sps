
DATASET ACTIVATE DataSet0.
RECODE  SA_1 SA_2 SA_5 SA_8 SA_10 SA_11 SA_15 SA_1 SA_16 SA_19 SA_20 (4=1) (3=2) (2=3) (1=4) INTO SA_1_inv SA_2_inv SA_5_inv SA_8_inv SA_10_inv SA_11_inv SA_15_inv SA_1_inv SA_16_inv SA_19_inv SA_20_inv.
EXECUTE.

RECODE TA_1 TA_3 TA_6 TA_7 TA_10 TA_13 TA_14 TA_16 TA_19 (4=1) (3=2) (2=3) (1=4) INTO TA_1_inv TA_3_inv TA_6_inv TA_7_inv TA_10_inv TA_13_inv TA_14_inv TA_16_inv TA_19_inv .
EXECUTE.

COMPUTE PHQ_average=MEAN(PHQ_1,PHQ_2,PHQ_3,PHQ_4,PHQ_5,PHQ_6,PHQ_7,PHQ_8,PHQ_9,PHQ_10).
EXECUTE.

COMPUTE SA_average=MEAN(SA_1_inv,	SA_2_inv,	SA_3,	SA_4,	SA_5_inv,	SA_6,	SA_7,	SA_8_inv,	SA_9,	SA_10_inv,	SA_11_inv,	SA_12,	SA_13,	SA_14,	SA_15_inv,	SA_16_inv,	SA_17,	SA_18,	SA_19_inv,	SA_20_inv).
EXECUTE.

COMPUTE TA_average=MEAN(TA_1_inv,	TA_2,	TA_3_inv,	TA_4,	TA_5,	TA_6_inv,	TA_7_inv,	TA_8,	TA_9,	TA_10_inv,	TA_11,	TA_12,	TA_13_inv,	TA_14_inv,	TA_15,	TA_16_inv,	TA_17,	TA_18,	TA_19_inv,	TA_20).
EXECUTE.

