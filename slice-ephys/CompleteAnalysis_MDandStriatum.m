%function analysisPlot_2

% Create table with filenames
Neuron_MDM = {'MD3_cell1_ipsi_R_2019_01_28',...
    'MD1_cell1_ipsi_R_2019_01_29','MD1_cell2_ipsi_R_2019_01_29','MD4_cell1_ipsi_R_2019_01_29','MD4_cell2_ipsi_R_2019_01_29',...
    'MD1_cell1_ipsi_R_2019_01_30','MD1_cell2_ipsi_R_2019_01_30','MD1_cell3_ipsi_R_2019_01_30','MD1_cell4_ipsi_R_2019_01_30', 'MD2_cell1_ipsi_R_2019_01_30',...
    'MD3_cell1_ipsi_R_2019_01_31', 'MD3_cell1_ipsi_R_2019_01_31','MD3_cell3_ipsi_R_2019_01_31','MD3_cell4_ipsi_R_2019_01_31',...
    'MD3_cell1_ipsi_R_2019_02_05','MD3_cell4_ipsi_R_2019_02_05','MD4_cell1_ipsi_R_2019_02_05',...
    'MD4_3_ipsi_R_2018_11_21', 'MD3_1_ipsi_R_2018_11_21',...
    'MD2ipsi_cel3r_4'
    };
Animal_MDM = {'66',...
    '67', '67', '67', '67',...
    '68', '68', '68', '68', '68',...
    'unknown', 'unknown', 'unknown', 'unknown',...
    '73', '73', '73',...
    '58', '58',...
    '45'
    };
RMP_MDM = {'MD3_cell1_ipsi_R_2019_01_28_0002.abf',...
    'MD1_cell1_ipsi_R_2019_01_29_0002.abf', 'MD1_cell2_ipsi_R_2019_01_29_0002.abf', 'MD4_cell1_ipsi_R_2019_01_29_0002.abf', 'MD4_cell2_ipsi_R_2019_01_29_0002.abf',...
    'MD1_cell1_ipsi_R_2019_01_30_0002.abf', 'MD1_cell2_ipsi_R_2019_01_30_0002.abf', 'MD1_cell4_ipsi_R_2019_01_30_0011.abf', 'MD2_cell1_ipsi_R_2019_01_30_0002.abf',...
    'MD3_cell1_ipsi_R_2019_01_31_0002.abf', 'MD3_cell4_ipsi_R_2019_01_31_0006.abf',...
    'MD3_cell1_ipsi_R_2019_02_05_0003.abf', 'MD3_cell4_ipsi_R_2019_02_05_0002.abf', 'MD4_cell1_ipsi_R_2019_02_05_0002.abf',...
    };
Step70Neg_MDM = {'MD3_cell1_ipsi_R_2019_01_28_0003.abf',...
    'MD1_cell1_ipsi_R_2019_01_29_0003.abf','MD1_cell2_ipsi_R_2019_01_29_0003.abf','MD4_cell1_ipsi_R_2019_01_29_0003.abf','MD4_cell2_ipsi_R_2019_01_29_0003.abf',...
    'MD1_cell1_ipsi_R_2019_01_30_0002.abf','MD1_cell2_ipsi_R_2019_01_30_0002.abf','MD1_cell3_ipsi_R_2019_01_30_0003.abf','MD1_cell4_ipsi_R_2019_01_30_0004.abf',...
    'MD3_cell1_ipsi_R_2019_01_31_0007.abf','MD3_cell2_ipsi_R_2019_01_31_0003.abf','MD3_cell3_ipsi_R_2019_01_31_0005.abf','MD3_cell4_ipsi_R_2019_01_31_0004.abf',...
    'MD3_cell1_ipsi_R_2019_02_05_0004.abf','MD3_cell4_ipsi_R_2019_02_05_0003.abf','MD4_cell1_ipsi_R_2019_02_05_0002.abf',...
    };
Step55Neg_MDM = {'MD3_cell1_ipsi_R_2019_01_28_0004.abf',...
    'MD1_cell1_ipsi_R_2019_01_29_0003.abf','MD1_cell2_ipsi_R_2019_01_29_0004.abf','MD4_cell1_ipsi_R_2019_01_29_0004.abf','MD4_cell2_ipsi_R_2019_01_29_0004.abf',...
    'MD1_cell1_ipsi_R_2019_01_30_0003.abf','MD1_cell2_ipsi_R_2019_01_30_0003.abf','MD1_cell3_ipsi_R_2019_01_30_0004.abf','MD1_cell4_ipsi_R_2019_01_30_0005.abf',...
    'MD3_cell1_ipsi_R_2019_01_31_0004.abf', 'MD3_cell2_ipsi_R_2019_01_31_0004.abf', 'MD3_cell3_ipsi_R_2019_01_31_0006.abf','MD3_cell4_ipsi_R_2019_01_31_0005.abf',...
    'MD3_cell1_ipsi_R_2019_02_05_0005.abf','MD3_cell4_ipsi_R_2019_02_05_0004.abf','MD4_cell1_ipsi_R_2019_02_05_0003.abf',...
    };
Step70Pos_MDM = {'MD3_cell1_ipsi_R_2019_01_28_0006.abf',...
    'MD1_cell1_ipsi_R_2019_01_29_0006.abf', 'MD1_cell2_ipsi_R_2019_01_29_0006.abf', 'MD4_cell1_ipsi_R_2019_01_29_0005.abf', 'MD4_cell2_ipsi_R_2019_01_29_0005.abf',...
    'MD1_cell1_ipsi_R_2019_01_30_0005.abf', 'MD1_cell2_ipsi_R_2019_01_30_0005.abf', 'MD1_cell3_ipsi_R_2019_01_30_0006.abf', 'MD1_cell4_ipsi_R_2019_01_30_0007.abf',...
    'MD3_cell1_ipsi_R_2019_01_31_0006.abf', 'MD3_cell3_ipsi_R_2019_01_31_0007.abf', 'MD3_cell4_ipsi_R_2019_01_31_0007.abf',...
    'MD3_cell1_ipsi_R_2019_02_05_0006.abf', 'MD3_cell4_ipsi_R_2019_02_05_0005.abf', 'MD4_cell1_ipsi_R_2019_02_05_0005.abf',...
    'MD4_3_ipsi_R_2018_11_21_0002.abf',...
    };
Step55Pos_MDM = {'MD3_cell1_ipsi_R_2019_01_28_0005.abf',...
    'MD1_cell1_ipsi_R_2019_01_29_0005.abf', 'MD1_cell2_ipsi_R_2019_01_29_0005.abf', 'MD4_cell1_ipsi_R_2019_01_29_0006.abf', 'MD4_cell2_ipsi_R_2019_01_29_0009.abf',...
    'MD1_cell1_ipsi_R_2019_01_30_0008.abf', 'MD1_cell2_ipsi_R_2019_01_30_0008.abf', 'MD1_cell3_ipsi_R_2019_01_30_0010.abf', 'MD1_cell4_ipsi_R_2019_01_30_0011.abf', 'MD3_cell3_ipsi_R_2019_01_31_0010.abf', 'MD3_cell4_ipsi_R_2019_01_31_0008.abf',...
    'MD3_cell1_ipsi_R_2019_02_05_0010.abf', 'MD3_cell4_ipsi_R_2019_02_05_0006.abf', 'MD4_cell1_ipsi_R_2019_02_05_0004.abf',...
    'MD4_3_ipsi_R_2018_11_21_0003.abf', 'MD3_1_ipsi_R_2018_11_21_0003.abf',...
    };
PPR_MDM = {'MD3_cell1_ipsi_R_2019_01_28_0001.abf',...
    'MD1_cell1_ipsi_R_2019_01_29_0001.abf','MD1_cell2_ipsi_R_2019_01_29_0001.abf','MD4_cell1_ipsi_R_2019_01_29_0001.abf','MD4_cell2_ipsi_R_2019_01_29_0001.abf',...
    'MD1_cell1_ipsi_R_2019_01_30_0001.abf','MD1_cell2_ipsi_R_2019_01_30_0001.abf','MD1_cell3_ipsi_R_2019_01_30_0002.abf','MD1_cell4_ipsi_R_2019_01_30_0003.abf','MD2_cell1_ipsi_R_2019_01_30_0001.abf',...
    'MD3_cell1_ipsi_R_2019_01_31_0001.abf','MD3_cell2_ipsi_R_2019_01_31_0002.abf','MD3_cell3_ipsi_R_2019_01_31_0004.abf','MD3_cell4_ipsi_R_2019_01_31_0003.abf',...
    'MD3_cell1_ipsi_R_2019_02_05_0002.abf','MD3_cell4_ipsi_R_2019_02_05_0001.abf','MD4_cell1_ipsi_R_2019_02_05_0001.abf',...
    'MD4_3_ipsi_R_2018_11_21_0001.abf', 'MD3_1_ipsi_R_2018_11_21_0001.abf',...
    };

PPR70_AP_MDM = {'2018_11_16_0004.abf'
    };
PPR55_AP_MDM = {'2018_11_16_0005.abf'
    };

CHIRP70_MDM = {'MD3_cell1_ipsi_R_2019_01_28_0009.abf',...
    'MD1_cell1_ipsi_R_2019_01_29_0007.abf','MD1_cell2_ipsi_R_2019_01_29_0008.abf','MD4_cell1_ipsi_R_2019_01_29_0007.abf','MD4_cell2_ipsi_R_2019_01_29_0010.abf',...
    'MD1_cell1_ipsi_R_2019_01_30_0009.abf','MD1_cell2_ipsi_R_2019_01_30_0010.abf','MD1_cell3_ipsi_R_2019_01_30_0011.abf',...
    'MD3_cell1_ipsi_R_2019_01_31_0008.abf','MD3_cell3_ipsi_R_2019_01_31_0011.abf','MD3_cell4_ipsi_R_2019_01_31_0009.abf',...
    'MD3_cell1_ipsi_R_2019_02_05_0011.abf','MD3_cell4_ipsi_R_2019_02_05_0007.abf','MD4_cell1_ipsi_R_2019_02_05_0006.abf',...
};
CHIRP55_MDM = {'MD3_cell1_ipsi_R_2019_01_28_0010.abf',...
    'MD1_cell2_ipsi_R_2019_01_29_0010.abf',...
    'MD1_cell1_ipsi_R_2019_01_30_0010.abf','MD1_cell2_ipsi_R_2019_01_30_0011.abf','MD1_cell3_ipsi_R_2019_01_30_0012.abf',...
    'MD3_cell1_ipsi_R_2019_01_31_0012.abf', 'MD3_cell3_ipsi_R_2019_01_31_0012.abf',...
    'MD3_cell1_ipsi_R_2019_02_05_0012.abf', 'MD4_cell1_ipsi_R_2019_02_05_0007.abf',...
};
LED_AP_70_MDM = {'MD3_cell1_ipsi_R_2019_01_28_0011.abf',...
    'MD1_cell1_ipsi_R_2019_01_29_0012.abf', 'MD1_cell2_ipsi_R_2019_01_29_0012.abf', 'MD4_cell1_ipsi_R_2019_01_29_0009.abf', 'MD4_cell2_ipsi_R_2019_01_29_0013.abf',...
    'MD1_cell1_ipsi_R_2019_01_30_0011.abf', 'MD1_cell2_ipsi_R_2019_01_30_0012.abf', 'MD1_cell3_ipsi_R_2019_01_30_0013.abf', 'MD1_cell4_ipsi_R_2019_01_30_0015.abf',...
    'MD3_cell1_ipsi_R_2019_01_31_0013.abf', 'MD3_cell3_ipsi_R_2019_01_31_0013.abf', 'MD3_cell4_ipsi_R_2019_01_31_0011.abf',...
    'MD3_cell1_ipsi_R_2019_02_05_0013.abf', 'MD3_cell4_ipsi_R_2019_02_05_0009.abf', 'MD4_cell1_ipsi_R_2019_02_05_0009.abf',...
};
LED_AP_55_MDM = {'MD3_cell1_ipsi_R_2019_01_28_0012.abf',...
    'MD1_cell2_ipsi_R_2019_01_29_0011.abf', 'MD4_cell1_ipsi_R_2019_01_29_0010.abf', 'MD4_cell2_ipsi_R_2019_01_29_0014.abf',...
    'MD1_cell1_ipsi_R_2019_01_30_0012.abf', 'MD1_cell2_ipsi_R_2019_01_30_0013.abf', 'MD1_cell3_ipsi_R_2019_01_30_0014.abf', 'MD1_cell4_ipsi_R_2019_01_30_0016.abf',...
    'MD3_cell1_ipsi_R_2019_01_31_0014.abf', 'MD3_cell3_ipsi_R_2019_01_31_0014.abf', 'MD3_cell4_ipsi_R_2019_01_31_0012.abf',...
    'MD3_cell1_ipsi_R_2019_02_05_0014.abf', 'MD3_cell4_ipsi_R_2019_02_05_0010.abf', 'MD4_cell1_ipsi_R_2019_02_05_0008.abf',...
    };
MDM_TABLE = table(Neuron_MDM, Animal_MDM, RMP_MDM, Step70Neg_MDM, Step55Neg_MDM, Step70Pos_MDM, Step55Pos_MDM, PPR_MDM, CHIRP70_MDM, CHIRP55_MDM, LED_AP_70_MDM, LED_AP_55_MDM);

Neuron_MDL = {'MD3contra_cel2r', 'MD3ipsi_cel1r',...
    'MD2_cell1_ipsi_R','MD2_cell2_ipsi_R','MD3_cell1_ipsi_R','MD3_cell2_ipsi_R',...
    'MD3_cell1_ipsi_R','MD3_cell2_ipsi_R','MD3_3_contra_R','MD3_4_contra_R'};
Animal_MDL = {'44','44',...
    '46','46','46','46',...
    '47','47','47','47'};
RMP_MDL = {'2018_07_18_0077.abf','2018_07_18_0085.abf',...
    '2018_11_22_0002.abf','MD2_cell2_ipsi_R_2018_11_22_0009.abf','MD3_cell1_ipsi_R_2018_11_22_0018.abf','2018_11_22_0028.abf',...
    '2018_11_27_0002.abf','2018_11_27_0010.abf','2018_11_27_0019.abf','2018_11_27_0028.abf',...
    'MD3_cell1_ipsi_R_2019_01_24_0002.abf','MD3_cell2_ipsi_R_2019_01_24_0003.abf',...
    'MD2_cell2_ipsi_R_2019_01_25_0003.abf','MD3_cell1_ipsi_R_2019_01_25_0003.abf','MD3_cell2_ipsi_R_2019_01_25_0006.abf',...
    'MD3_cell1_ipsi_R_2019_02_07_0005.abf','MD3_cell2_ipsi_R_2019_02_07_0003.abf',...
    '2018_10_19_0002.abf','2018_07_18_0077.abf','MD3_cell1_ipsi_R_2018_11_22_0018.abf','2018_11_22_0028.abf'
};
Step70Neg_MDL = {'2018_07_18_0077.abf','2018_07_18_0085.abf',...
    '2018_11_22_0002.abf','MD2_cell2_ipsi_R_2018_11_22_0009.abf','MD3_cell1_ipsi_R_2018_11_22_0018.abf','2018_11_22_0028.abf','MD3_cell1_ipsi_R_2018_11_22_0018.abf',...
    '2018_11_27_0002.abf','2018_11_27_0010.abf','2018_11_27_0019.abf','2018_11_27_0028.abf',...
    'MD3_cell1_ipsi_R_2019_01_24_0002.abf','MD3_cell2_ipsi_R_2019_01_24_0003.abf',...
    'MD2_cell2_ipsi_R_2019_01_25_0003.abf','MD3_cell1_ipsi_R_2019_01_25_0003.abf','MD3_cell2_ipsi_R_2019_01_25_0006.abf',...
    'MD3_cell1_ipsi_R_2019_02_07_0005.abf','MD3_cell2_ipsi_R_2019_02_07_0003.abf',...
    '2018_10_19_0002.abf'
    };
Step55Neg_MDL = {'2018_07_18_0078.abf','2018_07_18_0086.abf',...
    '2018_11_22_0003.abf','MD2_cell2_ipsi_R_2018_11_22_0010.abf','MD3_cell1_ipsi_R_2018_11_22_0019.abf','2018_11_22_0029.abf',...
    '2018_11_27_0003.abf','2018_11_27_0011.abf','2018_11_27_0020.abf','2018_11_27_0029.abf',...
    'MD3_cell1_ipsi_R_2019_01_24_0003.abf','MD3_cell2_ipsi_R_2019_01_24_0004.abf',...
    'MD2_cell2_ipsi_R_2019_01_25_0004.abf','MD3_cell1_ipsi_R_2019_01_25_0004.abf','MD3_cell2_ipsi_R_2019_01_25_0007.abf',...
    'MD3_cell1_ipsi_R_2019_02_07_0006.abf','MD3_cell2_ipsi_R_2019_02_07_0004.abf'};
Step70Pos_MDL = {'2018_07_18_0077.abf','2018_07_18_0085.abf',...
    '2018_11_22_0002.abf','MD2_cell2_ipsi_R_2018_11_22_0009.abf','MD3_cell1_ipsi_R_2018_11_22_0018.abf','2018_11_22_0028.abf',...
    '2018_11_27_0002.abf','2018_11_27_0010.abf','2018_11_27_0019.abf','2018_11_27_0028.abf',...
    'MD3_cell1_ipsi_R_2019_01_24_0004.abf','MD3_cell2_ipsi_R_2019_01_24_0006.abf',...
    'MD2_cell2_ipsi_R_2019_01_25_0006.abf','MD3_cell1_ipsi_R_2019_01_25_0005.abf','MD3_cell2_ipsi_R_2019_01_25_0008.abf',...
    'MD3_cell1_ipsi_R_2019_02_07_0007.abf','MD3_cell2_ipsi_R_2019_02_07_0005.abf'};
Step55Pos_MDL = {'2018_07_18_0078.abf','2018_07_18_0086.abf',...
    '2018_11_22_0003.abf','MD2_cell2_ipsi_R_2018_11_22_0010.abf','MD3_cell1_ipsi_R_2018_11_22_0019.abf','2018_11_22_0029.abf',...
    '2018_11_27_0003.abf','2018_11_27_0011.abf','2018_11_27_0020.abf','2018_11_27_0029.abf',...
    'MD3_cell1_ipsi_R_2019_01_24_0007.abf','MD3_cell2_ipsi_R_2019_01_24_0009.abf',...
    'MD2_cell2_ipsi_R_2019_01_25_0009.abf','MD3_cell1_ipsi_R_2019_01_25_0009.abf','MD3_cell2_ipsi_R_2019_01_25_0011.abf',...
    'MD3_cell1_ipsi_R_2019_02_07_0010.abf','MD3_cell2_ipsi_R_2019_02_07_0008.abf'};
PPR_MDL = {'2018_07_18_0076.abf','2018_07_18_0084.abf',...
    '2018_11_22_0001.abf','MD2_cell2_ipsi_R_2018_11_22_0008.abf','MD3_cell1_ipsi_R_2018_11_22_0017.abf','2018_11_22_0027.abf',...
    '2018_11_27_0001.abf','2018_11_27_0009.abf','2018_11_27_0018.abf','2018_11_27_0027.abf',...
    'MD3_cell1_ipsi_R_2019_01_24_0001.abf','MD3_cell2_ipsi_R_2019_01_24_0001.abf',...
    'MD2_cell2_ipsi_R_2019_01_25_0001.abf','MD3_cell1_ipsi_R_2019_01_25_0002.abf','MD3_cell2_ipsi_R_2019_01_25_0004.abf',...
    'MD3_cell1_ipsi_R_2019_02_07_0003.abf','MD3_cell2_ipsi_R_2019_02_07_0001.abf',...
    '2018_10_19_0001.abf'};
PPR70_AP_MDL = {'2018_07_18_0079.abf',...
    'MD2_cell2_ipsi_R_2018_11_22_0015.abf','MD3_cell1_ipsi_R_2018_11_22_0020.abf',...
    '2018_11_22_0030.abf',...
    '2018_11_27_0004.abf','2018_11_27_0012.abf',...
    '2018_10_19_0005.abf'};
PPR55_AP_MDL = {'MD2_cell2_ipsi_R_2018_11_22_0016.abf','MD3_cell1_ipsi_R_2018_11_22_0021.abf',...
    '2018_11_22_0031.abf',...
    '2018_11_27_0005.abf','2018_11_27_0013.abf','2018_11_27_0022.abf',...
    '2018_10_19_0004.abf'};
CHIRP70_MDL = {
    'MD3_cell1_ipsi_R_2019_01_24_0010.abf',...
    'MD2_cell2_ipsi_R_2019_01_25_0012.abf','MD3_cell1_ipsi_R_2019_01_25_0010.abf','MD3_cell2_ipsi_R_2019_01_25_0012.abf',...
    'MD3_cell1_ipsi_R_2019_02_07_0011.abf','MD3_cell2_ipsi_R_2019_02_07_0009.abf'};
CHIRP55_MDL = {
    'MD3_cell1_ipsi_R_2019_01_24_0011.abf','MD3_cell2_ipsi_R_2019_01_24_0012.abf',...
    'MD2_cell2_ipsi_R_2019_01_25_0013.abf','MD3_cell1_ipsi_R_2019_01_25_0011.abf','MD3_cell2_ipsi_R_2019_01_25_0013.abf',...
    'MD3_cell1_ipsi_R_2019_02_07_0012.abf','MD3_cell2_ipsi_R_2019_02_07_0010.abf'};
LED_AP_70_MDL = {'MD3_cell1_ipsi_R_2019_01_24_0013.abf','MD3_cell2_ipsi_R_2019_01_24_0013.abf',...
    'MD3_cell1_ipsi_R_2019_02_07_0013.abf','MD3_cell2_ipsi_R_2019_02_07_0011.abf'};
LED_AP_55_MDL = {'MD3_cell1_ipsi_R_2019_01_24_0014.abf','MD3_cell2_ipsi_R_2019_01_24_0014.abf',...
    'MD3_cell1_ipsi_R_2019_02_07_0014.abf','MD3_cell2_ipsi_R_2019_02_07_0012.abf'};

MDL_TABLE = table(Neuron_MDL, Animal_MDL, RMP_MDL, Step70Neg_MDL, Step55Neg_MDL, Step70Pos_MDL, Step55Pos_MDL, PPR_MDL, CHIRP70_MDL, CHIRP55_MDL, LED_AP_70_MDL, LED_AP_55_MDL, PPR70_AP_MDL, PPR70_AP_MDM);

% Create table with filenames
Animal_DS = {'',...
    };
Neuron_DS = {'',...
    };
PPR_DS = {'DS1_cell3_R_2019_11_21_0001.abf',...
    'DS1_cell1_R_2019_12_03_0001.abf',...
    'DS1_cell1_R_2019_12_05_0001.abf','DS1_cell2_R_2019_12_05_0001.abf','DS1_cell3_R_2019_12_05_0002.abf','DS2_cell1_R_2019_12_05_0001.abf','DS2_cell3_R_2019_12_05_0001.abf','DS3_cell1_R_2019_12_05_0002.abf'...
    'DS1_cell1_L_2019_12_16_0002.abf','DS1_cell2_L_2019_12_16_0002.abf','DS1_cell3_L_2019_12_16_0001.abf','DS2_cell1_L_2019_12_16_0002.abf',...
    'DS1_cell1_L_2019_12_18_0001.abf','DS1_cell2_L_2019_12_18_0001.abf','DS1_cell3_L_2019_12_18_0001.abf','DS3_cell1_L_2019_12_18_0001.abf','DS3_cell2_L_2019_12_18_0001.abf',...
    'DS1_cell2_L_2020_02_04_0001.abf','DS2_cell1_L_2020_02_04_0001.abf','DS2_cell2_L_2020_02_04_0003.abf','DS1_cell1_L_2020_02_06_0001.abf'
    };
RMP_DS = {'',...
    };
Step70Neg_DS = {'DS1_cell3_R_2019_11_21_0002.abf',...
    'DS1_cell1_R_2019_12_05_0002.abf','DS1_cell2_R_2019_12_05_0002.abf','DS3_cell1_R_2019_12_05_0003.abf'...
    'DS1_cell1_L_2019_12_16_0003.abf','DS1_cell2_L_2019_12_16_0003.abf','DS1_cell3_L_2019_12_16_0002.abf','DS2_cell1_L_2019_12_16_0003.abf',...
    'DS1_cell1_L_2019_12_18_0002.abf','DS1_cell2_L_2019_12_18_0002.abf','DS1_cell3_L_2019_12_18_0002.abf','DS3_cell1_L_2019_12_18_0002.abf','DS3_cell2_L_2019_12_18_0002.abf',...
    'DS1_cell2_L_2020_02_04_0002.abf','DS2_cell1_L_2020_02_04_0002.abf','DS2_cell2_L_2020_02_04_0004.abf','DS1_cell1_L_2020_02_06_0002.abf'
    };
Step70Pos_DS = {'DS1_cell3_R_2019_11_21_0003.abf',...
    'DS1_cell1_R_2019_12_05_0003.abf','DS1_cell2_R_2019_12_05_0003.abf','DS1_cell3_R_2019_12_05_0004.abf','DS2_cell1_R_2019_12_05_0003.abf','DS2_cell3_R_2019_12_05_0003.abf','DS3_cell1_R_2019_12_05_0004.abf'...
    'DS1_cell1_L_2019_12_16_0004.abf','DS1_cell2_L_2019_12_16_0004.abf','DS1_cell3_L_2019_12_16_0003.abf','DS2_cell1_L_2019_12_16_0004.abf',...
    'DS1_cell1_L_2019_12_18_0003.abf','DS1_cell2_L_2019_12_18_0003.abf','DS1_cell3_L_2019_12_18_0003.abf','DS3_cell1_L_2019_12_18_0003.abf','DS3_cell2_L_2019_12_18_0003.abf',...
    'DS1_cell2_L_2020_02_04_0003.abf','DS2_cell1_L_2020_02_04_0003.abf','DS2_cell2_L_2020_02_04_0005.abf','DS1_cell1_L_2020_02_06_0003.abf'
    };
CHIRP70_DS = {
    'DS1_cell1_R_2019_12_05_0004.abf','DS1_cell2_R_2019_12_05_0004.abf','DS1_cell3_R_2019_12_05_0005.abf','DS2_cell1_R_2019_12_05_0004.abf','DS2_cell3_R_2019_12_05_0004.abf','DS3_cell1_R_2019_12_05_0005.abf'...
    'DS1_cell1_L_2019_12_16_0005.abf','DS1_cell2_L_2019_12_16_0005.abf','DS1_cell3_L_2019_12_16_0004.abf','DS2_cell1_L_2019_12_16_0005.abf',...
    'DS1_cell1_L_2019_12_18_0004.abf','DS1_cell2_L_2019_12_18_0004.abf','DS1_cell3_L_2019_12_18_0004.abf','DS3_cell1_L_2019_12_18_0004.abf','DS3_cell2_L_2019_12_18_0004.abf'
};
PPR70_AP_DS = {'',...
    };
LED_AP_70_DS = {'',...
};

DS_TABLE = table(Neuron_DS, Animal_DS, RMP_DS, Step70Neg_DS, Step70Pos_DS, PPR_DS, CHIRP70_DS, LED_AP_70_DS);


Animal_VS = {'',...
    };
Neuron_VS = {'',...
    };
PPR_VS = {'VS1_cell1_R_2019_11_22_0003.abf','VS2_cell1_R_2019_11_22_0002.abf',...
    'VS1_cell3_R_2019_11_26_0003.abf',...
    'VS1_cell1_R_2019_11_28_0001.abf','VS1_cell2_R_2019_11_28_0001.abf','VS1_cell3_R_2019_11_28_0001.abf','VS2_cell1_R_2019_11_28_0001.abf','VS2_cell2_R_2019_11_28_0001.abf','VS2_cell3_R_2019_11_28_0002.abf',...
    'DS1_cell1_L_2019_12_19_0001.abf','DS1_cell2_L_2019_12_19_0001.abf','DS3_cell1_L_2019_12_19_0001.abf',...
    'VS1_cell3_L_2019_12_20_0001.abf','VS2_cell1_L_2019_12_20_0001.abf','VS2_cell3_L_2019_12_20_0003.abf',...
    'VS1_cell1_L_2020_01_29_0001.abf','VS1_cell2_L_2020_01_29_0001.abf','VS1_cell3_L_2020_01_29_0001.abf','VS2_cell1_L_2020_01_29_0001.abf','VS2_cell2_L_2020_01_29_0002.abf',...
    'VS1_cell1_L_2020_01_29_0001.abf','VS1_cell2_L_2020_01_29_0001.abf','VS1_cell3_L_2020_01_29_0001.abf'
    };
RMP_VS = {'',...
    };
Step70Neg_VS = {'VS1_cell1_R_2019_11_22_0004.abf','VS2_cell1_R_2019_11_22_0003.abf',...
    'VS1_cell3_R_2019_11_26_0004.abf',...
    'VS1_cell1_R_2019_11_28_0002.abf','VS1_cell2_R_2019_11_28_0002.abf','VS1_cell3_R_2019_11_28_0002.abf','VS2_cell1_R_2019_11_28_0002.abf','VS2_cell2_R_2019_11_28_0002.abf','VS2_cell3_R_2019_11_28_0003.abf',...
    'DS1_cell1_L_2019_12_19_0002.abf','DS1_cell2_L_2019_12_19_0002.abf','DS3_cell1_L_2019_12_19_0002.abf',...
    'VS1_cell3_L_2019_12_20_0002.abf','VS2_cell1_L_2019_12_20_0002.abf',...
    'VS1_cell1_L_2020_01_29_0002.abf','VS1_cell2_L_2020_01_29_0002.abf','VS1_cell3_L_2020_01_29_0002.abf','VS2_cell1_L_2020_01_29_0002.abf','VS2_cell2_L_2020_01_29_0003.abf',...
    'VS1_cell1_L_2020_01_29_0002.abf','VS1_cell2_L_2020_01_29_0002.abf','VS1_cell3_L_2020_01_29_0002.abf'
    };
Step70Pos_VS = {'VS1_cell1_R_2019_11_22_0010.abf','VS2_cell1_R_2019_11_22_0004.abf',...
    'VS1_cell3_R_2019_11_26_0005.abf',...
    'VS1_cell1_R_2019_11_28_0003.abf','VS1_cell2_R_2019_11_28_0003.abf','VS1_cell3_R_2019_11_28_0003.abf','VS2_cell1_R_2019_11_28_0003.abf','VS2_cell2_R_2019_11_28_0003.abf','VS2_cell3_R_2019_11_28_0004.abf',...
    'DS1_cell1_L_2019_12_19_0003.abf','DS1_cell2_L_2019_12_19_0003.abf','DS3_cell1_L_2019_12_19_0003.abf',...
    'VS1_cell3_L_2019_12_20_0003.abf','VS2_cell1_L_2019_12_20_0003.abf','VS2_cell3_L_2019_12_20_0005.abf',...
    'VS1_cell1_L_2020_01_29_0003.abf','VS1_cell2_L_2020_01_29_0003.abf','VS1_cell3_L_2020_01_29_0003.abf','VS2_cell1_L_2020_01_29_0003.abf','VS2_cell2_L_2020_01_29_0004.abf',...
    'VS1_cell1_L_2020_01_29_0003.abf','VS1_cell2_L_2020_01_29_0003.abf','VS1_cell3_L_2020_01_29_0003.abf'
    };
CHIRP70_VS = {'VS1_cell1_R_2019_11_22_0007.abf',...
    'VS1_cell3_R_2019_11_26_0006.abf',...
    'VS1_cell1_R_2019_11_28_0004.abf','VS1_cell2_R_2019_11_28_0004.abf','VS1_cell3_R_2019_11_28_0005.abf','VS2_cell1_R_2019_11_28_0004.abf','VS2_cell2_R_2019_11_28_0004.abf','VS2_cell3_R_2019_11_28_0005.abf',...
    'DS1_cell1_L_2019_12_19_0004.abf','DS1_cell2_L_2019_12_19_0004.abf','DS3_cell1_L_2019_12_19_0004.abf',...
    'VS1_cell3_L_2019_12_20_0004.abf','VS2_cell1_L_2019_12_20_0004.abf','VS2_cell3_L_2019_12_20_0006.abf'
};
PPR70_AP_VS = {'',...
    };
LED_AP_70_VS = {'',...
};

VS_TABLE = table(Neuron_VS, Animal_VS, RMP_VS, Step70Neg_VS, Step70Pos_VS, PPR_VS, CHIRP70_VS, LED_AP_70_VS);

clearvars -except DS_TABLE VS_TABLE MDM_TABLE MDL_TABLE







%% Basis electrophysiological properties analysis and plotting

% Do analysis
[R_input.MDL_R, Tau.MDL_R, gof.MDL_R, Sag_Ratio20.MDL_R, Capacitance.MDL_R] = RMP_physiology(MDL_TABLE.Step70Neg_MDL,'MD');
[R_input.MDM_R, Tau.MDM_R, gof.MDM_R, Sag_Ratio20.MDM_R, Capacitance.MDM_R] = RMP_physiology(MDM_TABLE.Step70Neg_MDM,'MD');
[R_input.MDL_R_55, Tau.MDL_R_55, gof.MDL_R_55, Sag_Ratio20.MDL_R_55, Capacitance.MDL_R_55] = RMP_physiology(MDL_TABLE.Step55Neg_MDL,'MD');
[R_input.MDM_R_55, Tau.MDM_R_55, gof.MDM_R_55, Sag_Ratio20.MDM_R_55, Capacitance.MDM_R_55] = RMP_physiology(MDM_TABLE.Step55Neg_MDM,'MD');
[R_input.VS_R, Tau.VS_R, gof.VS_R, Sag_Ratio20.VS_R, Capacitance.VS_R] = RMP_physiology(VS_TABLE.Step70Neg_VS,'Str');
[R_input.DS_R, Tau.DS_R, gof.DS_R, Sag_Ratio20.DS_R, Capacitance.DS_R] = RMP_physiology(DS_TABLE.Step70Neg_DS,'Str');


% CALCULATE INPUT RESISTANCE

figure
subplot(1,3,1)
Ri = [R_input.MDL_R R_input.MDM_R];
RiGroups = [zeros(1,size(R_input.MDL_R,2)),ones(1,size(R_input.MDM_R,2))];
boxplot(Ri,RiGroups,'Labels',{'MDL','MDM'})
hold on
scatter(ones(size(R_input.MDL_R)).*(1+(rand(size(R_input.MDL_R))-0.5)/5),R_input.MDL_R,10,'r','filled')
scatter(ones(size(R_input.MDM_R)).*(2+(rand(size(R_input.MDM_R))-0.5)/5),R_input.MDM_R,10,'r','filled')
title('-70mV')
ylabel('Ri (MOhm)')
[R_input.p,R_input.table,R_input.stats] = anova1(Ri',RiGroups', 'off');

subplot(1,3,2)
Tau2 = [Tau.MDL_R Tau.MDM_R];
TauGroups = [zeros(1,size(Tau.MDL_R,2)),ones(1,size(Tau.MDM_R,2))];
boxplot(Tau2, TauGroups,'Labels',{'MDL','MDM'})
hold on
scatter(ones(size(Tau.MDL_R)).*(1+(rand(size(Tau.MDL_R))-0.5)/5),Tau.MDL_R,10,'r','filled')
scatter(ones(size(Tau.MDM_R)).*(2+(rand(size(Tau.MDM_R))-0.5)/5),Tau.MDM_R,10,'r','filled')
title('-70mV')
ylabel('Tau (ms)')
[Tau.p,Tau.table,Tau.stats] = anova1(Tau2',TauGroups', 'off');

subplot(1,3,3)
Capacitance2 = [Capacitance.MDL_R Capacitance.MDM_R];
CapacitanceGroups = [zeros(1,size(Capacitance.MDL_R,2)),ones(1,size(Capacitance.MDM_R,2))];
boxplot(Capacitance2, CapacitanceGroups,'Labels',{'MDL','MDM'})
hold on
scatter(ones(size(Capacitance.MDL_R)).*(1+(rand(size(Capacitance.MDL_R))-0.5)/5),Capacitance.MDL_R,10,'r','filled')
scatter(ones(size(Capacitance.MDM_R)).*(2+(rand(size(Capacitance.MDM_R))-0.5)/5),Capacitance.MDM_R,10,'r','filled')
title('-70mV')
ylabel('Capacitance (pF)')
[Capacitance.p,Capacitance.table,Capacitance.stats] = anova1(Capacitance2',CapacitanceGroups', 'off');

figure
subplot(1,3,1)
Ri = [R_input.DS_R R_input.VS_R];
RiGroups = [zeros(1,size(R_input.DS_R,2)),ones(1,size(R_input.VS_R,2))];
boxplot(Ri,RiGroups,'Labels',{'DS','VS'})
hold on
scatter(ones(size(R_input.DS_R)).*(1+(rand(size(R_input.DS_R))-0.5)/5),R_input.DS_R,10,'r','filled')
scatter(ones(size(R_input.VS_R)).*(2+(rand(size(R_input.VS_R))-0.5)/5),R_input.VS_R,10,'r','filled')
title('-70mV')
ylabel('Ri (MOhm)')
[R_input.p,R_input.table,R_input.stats] = anova1(Ri',RiGroups', 'off');

subplot(1,3,2)
Tau2 = [Tau.DS_R Tau.VS_R];
TauGroups = [zeros(1,size(Tau.DS_R,2)),ones(1,size(Tau.VS_R,2))];
boxplot(Tau2, TauGroups,'Labels',{'DS','VS'})
hold on
scatter(ones(size(Tau.DS_R)).*(1+(rand(size(Tau.DS_R))-0.5)/5),Tau.DS_R,10,'r','filled')
scatter(ones(size(Tau.VS_R)).*(2+(rand(size(Tau.VS_R))-0.5)/5),Tau.VS_R,10,'r','filled')
title('-70mV')
ylabel('Tau (ms)')
[Tau.p,Tau.table,Tau.stats] = anova1(Tau2',TauGroups', 'off');

subplot(1,3,3)
Capacitance2 = [Capacitance.DS_R Capacitance.VS_R];
CapacitanceGroups = [zeros(1,size(Capacitance.DS_R,2)),ones(1,size(Capacitance.VS_R,2))];
boxplot(Capacitance2, CapacitanceGroups,'Labels',{'DS','VS'})
hold on
scatter(ones(size(Capacitance.DS_R)).*(2+(rand(size(Capacitance.DS_R))-0.5)/5),Capacitance.DS_R,10,'r','filled')
scatter(ones(size(Capacitance.VS_R)).*(1+(rand(size(Capacitance.VS_R))-0.5)/5),Capacitance.VS_R,10,'r','filled')
title('-70mV')
ylabel('Capacitance (pF)')
[Capacitance.p,Capacitance.table,Capacitance.stats] = anova1(Capacitance2',CapacitanceGroups', 'off');


figure
subplot(1,2,1)
SagRatio = [Sag_Ratio20.MDL_R Sag_Ratio20.MDM_R];
SagRatioGroups = [zeros(1,size(Sag_Ratio20.MDL_R,2)),ones(1,size(Sag_Ratio20.MDM_R,2))];
boxplot(SagRatio, SagRatioGroups,'Labels',{'MDL','MDM'})
hold on
scatter(ones(size(Sag_Ratio20.MDL_R)).*(1+(rand(size(Sag_Ratio20.MDL_R))-0.5)/5),Sag_Ratio20.MDL_R,10,'r','filled')
scatter(ones(size(Sag_Ratio20.MDM_R)).*(2+(rand(size(Sag_Ratio20.MDM_R))-0.5)/5),Sag_Ratio20.MDM_R,10,'r','filled')
title('Sag ratio -70mV')
[Sag_Ratio20.p,Sag_Ratio20.table,Sag_Ratio20.stats] = anova1(SagRatio',SagRatioGroups', 'off');

subplot(1,2,2)
SagRatio = [Sag_Ratio20.MDL_R_55 Sag_Ratio20.MDM_R_55];
SagRatioGroups = [zeros(1,size(Sag_Ratio20.MDL_R_55,2)),ones(1,size(Sag_Ratio20.MDM_R_55,2))];
boxplot(SagRatio, SagRatioGroups,'Labels',{'MDL','MDM'})
hold on
scatter(ones(size(Sag_Ratio20.MDL_R_55)).*(1+(rand(size(Sag_Ratio20.MDL_R_55))-0.5)/5),Sag_Ratio20.MDL_R_55,10,'r','filled')
scatter(ones(size(Sag_Ratio20.MDM_R_55)).*(2+(rand(size(Sag_Ratio20.MDM_R_55))-0.5)/5),Sag_Ratio20.MDM_R_55,10,'r','filled')
title('Sag ratio -55mV')
[Sag_Ratio20.p_55,Sag_Ratio20.table_55,Sag_Ratio20.stats_55] = anova1(SagRatio',SagRatioGroups', 'off');


figure
SagRatio = [Sag_Ratio20.DS_R Sag_Ratio20.VS_R];
SagRatioGroups = [zeros(1,size(Sag_Ratio20.DS_R,2)),ones(1,size(Sag_Ratio20.VS_R,2))];
boxplot(SagRatio, SagRatioGroups,'Labels',{'DS','VS'})
hold on
scatter(ones(size(Sag_Ratio20.DS_R)).*(1+(rand(size(Sag_Ratio20.DS_R))-0.5)/5),Sag_Ratio20.DS_R,10,'r','filled')
scatter(ones(size(Sag_Ratio20.VS_R)).*(2+(rand(size(Sag_Ratio20.VS_R))-0.5)/5),Sag_Ratio20.VS_R,10,'r','filled')
title('Sag ratio -70mV')
[Sag_Ratio20.p,Sag_Ratio20.table,Sag_Ratio20.stats] = anova1(SagRatio',SagRatioGroups', 'off');

% % Apply benjamin hochleys false discovery rate
% FDR = mafdr([R_input.p; Tau.p; Capacitance.p; Sag_Ratio20.p; Sag_Ratio20.p_55],'BHFDR','true');
% R_input.p = FDR(1);
% Tau.p = FDR(2);
% Capacitance.p = FDR(3);
% Sag_Ratio20.p = FDR(4);
% Sag_Ratio20.p_55 = FDR(5);

%% Do analysis
[eEPSC_MDL] = eEPSC_ratio(MDL_TABLE.PPR_MDL,'MD');
[eEPSC_MDM] = eEPSC_ratio(MDM_TABLE.PPR_MDM,'MD');

figure
hold on
errorbar(1:5,mean(eEPSC_MDL.ratio,1),std(eEPSC_MDL.ratio,1)/sqrt(size(eEPSC_MDL.ratio,1)),'b')
plot(eEPSC_MDL.ratio','b')
errorbar(1:5,mean(eEPSC_MDM.ratio,1),std(eEPSC_MDM.ratio,1)/sqrt(size(eEPSC_MDM.ratio,1)),'g')
plot(eEPSC_MDM.ratio','g')
legend('show',{'MDL','MDM'});

figure
hold on
errorbar(1:5,mean(eEPSC_MDL.respTime,1),std(eEPSC_MDL.respTime,1)/sqrt(size(eEPSC_MDL.respTime,1)),'b')
errorbar(1:5,mean(eEPSC_MDM.respTime,1),std(eEPSC_MDM.respTime,1)/sqrt(size(eEPSC_MDM.respTime,1)),'g')
legend('show',{'MDL','MDM'});

for i = 2:5
    [eEPSC_MD.p(i), l, eEPSC_MD.stats(i)] = ranksum(eEPSC_MDL.ratio(:,i),eEPSC_MDM.ratio(:,i));
end
eEPSC_MD.p = mafdr(eEPSC_MD.p(2:5),'BHFDR','true');
%eEPSC_MD_p = eEPSC_MD_p*4;

[eEPSC_VS] = eEPSC_ratio(VS_TABLE.PPR_VS,'Str');
[eEPSC_DS] = eEPSC_ratio(DS_TABLE.PPR_DS,'Str');

figure
hold on
errorbar(1:5,mean(eEPSC_VS.ratio,1),std(eEPSC_VS.ratio,1)/sqrt(size(eEPSC_VS.ratio,1)),'b')
plot(eEPSC_VS.ratio','b')
errorbar(1:5,mean(eEPSC_DS.ratio,1),std(eEPSC_DS.ratio,1)/sqrt(size(eEPSC_DS.ratio,1)),'g')
plot(eEPSC_DS.ratio','g')
legend('show',{'VS','DS'});

figure
hold on
errorbar(1:5,mean(eEPSC_VS.respTime,1),std(eEPSC_VS.respTime,1)/sqrt(size(eEPSC_VS.respTime,1)),'b')
errorbar(1:5,mean(eEPSC_DS.respTime,1),std(eEPSC_DS.respTime,1)/sqrt(size(eEPSC_DS.respTime,1)),'g')
legend('show',{'VS','DS'});

for i = 2:5
    [eEPSC_STR.p(i), l, eEPSC_STR.stats(i)] = ranksum(eEPSC_DS.ratio(:,i),eEPSC_VS.ratio(:,i));
end
eEPSC_STR.p = mafdr(eEPSC_STR.p(2:5),'BHFDR','true');
%eEPSC_STR_p = eEPSC_STR_p*4;


%% Positive step protocol firing properties
[I_input.MDL_70, N_APs.MDL_70] = Step_prot_firing(MDL_TABLE.Step70Pos_MDL,'MD');
[I_input.MDM_70, N_APs.MDM_70] = Step_prot_firing(MDM_TABLE.Step70Pos_MDM,'MD');
[I_input.MDL_55, N_APs.MDL_55] = Step_prot_firing(MDL_TABLE.Step55Pos_MDL,'MD');
[I_input.MDM_55, N_APs.MDM_55] = Step_prot_firing(MDM_TABLE.Step55Pos_MDM,'MD');

[I_input.MDL_70_SteadyState, N_APs.MDL_70_SteadyState] = Step_prot_firing_SteadyState(MDL_TABLE.Step70Pos_MDL,'MD');
[I_input.MDM_70_SteadyState, N_APs.MDM_70_SteadyState] = Step_prot_firing_SteadyState(MDM_TABLE.Step70Pos_MDM,'MD');
[I_input.MDL_55_SteadyState, N_APs.MDL_55_SteadyState] = Step_prot_firing_SteadyState(MDL_TABLE.Step55Pos_MDL,'MD');
[I_input.MDM_55_SteadyState, N_APs.MDM_55_SteadyState] = Step_prot_firing_SteadyState(MDM_TABLE.Step55Pos_MDM,'MD');

[I_input.MDL_70_Burst, N_APs.MDL_70_Burst, TimeFirst_AP.MDL_70_Burst] = Step_prot_firing_Burst(MDL_TABLE.Step70Pos_MDL,'MD');
[I_input.MDM_70_Burst, N_APs.MDM_70_Burst, TimeFirst_AP.MDM_70_Burst] = Step_prot_firing_Burst(MDM_TABLE.Step70Pos_MDM,'MD');
[I_input.MDL_55_Burst, N_APs.MDL_55_Burst, TimeFirst_AP.MDL_55_Burst] = Step_prot_firing_Burst(MDL_TABLE.Step55Pos_MDL,'MD');
[I_input.MDM_55_Burst, N_APs.MDM_55_Burst, TimeFirst_AP.MDM_55_Burst] = Step_prot_firing_Burst(MDM_TABLE.Step55Pos_MDM,'MD');

figure
subplot(1,2,1)
hold on
errorbar(I_input.MDL_70(11,1:5),mean([N_APs.MDL_70(11:17,1:5); N_APs.MDL_70(3:10,[1 4 8 11 14])],1),std([N_APs.MDL_70(11:17,1:5); N_APs.MDL_70(3:10,[1 4 8 11 14])],1)/sqrt(size([N_APs.MDL_70(11:17,1:5); N_APs.MDL_70(3:10,[1 4 8 11 14])],1)))
errorbar(I_input.MDM_70(1,1:5),mean([N_APs.MDM_70(1:15,1:5); N_APs.MDM_70([16],[1 4 8 11 14])],1),std([N_APs.MDM_70(1:15,1:5); N_APs.MDM_70([16],[1 4 8 11 14])],1)/sqrt(size([N_APs.MDM_70(1:15,1:5); N_APs.MDM_70([16],[1 4 8 11 14])],1)))
legend({'MDL 70mV','MDM 70mV'})

% subplot(1,2,2)
% hold on
% errorbar(I_input.MDL_55(11,1:5),mean(N_APs.MDL_55(11:17,1:5),1),std(N_APs.MDL_55(11:17,1:5),1)/sqrt(size(N_APs.MDL_55(11:17,1:5),1)))
% errorbar(I_input.MDM_55(1,1:5),mean(N_APs.MDM_55(2:14,1:5),1),std(N_APs.MDM_55(2:14,1:5),1)/sqrt(size(N_APs.MDM_55(2:14,1:5),1)))
% legend({'MDL 55mV','MDM 55mV'})

figure
subplot(1,2,1)
hold on
errorbar(I_input.MDL_70_Burst(11,1:5),mean([N_APs.MDL_70_Burst(11:17,1:5); N_APs.MDL_70_Burst(3:10,[1 4 8 11 14])],1),std([N_APs.MDL_70_Burst(11:17,1:5); N_APs.MDL_70_Burst(3:10,[1 4 8 11 14])],1)/sqrt(size([N_APs.MDL_70_Burst(11:17,1:5); N_APs.MDL_70_Burst(3:10,[1 4 8 11 14])],1)))
errorbar(I_input.MDM_70_Burst(1,1:5),mean([N_APs.MDM_70_Burst(1:15,1:5); N_APs.MDM_70_Burst([16],[1 4 8 11 14])],1),std([N_APs.MDM_70_Burst(1:15,1:5); N_APs.MDM_70_Burst([16],[1 4 8 11 14])],1)/sqrt(size([N_APs.MDM_70_Burst(1:15,1:5); N_APs.MDM_70_Burst([16],[1 4 8 11 14])],1)))
legend({'MDL 70mV','MDM 70mV burst'})

% subplot(1,2,2)
% hold on
% errorbar(I_input.MDL_55_Burst(11,1:5),mean(N_APs.MDL_55_Burst(11:17,1:5),1),std(N_APs.MDL_55_Burst(11:17,1:5),1)/sqrt(size(N_APs.MDL_55_Burst(11:17,1:5),1)))
% errorbar(I_input.MDM_55_Burst(1,1:5),mean(N_APs.MDM_55_Burst(2:14,1:5),1),std(N_APs.MDM_55_Burst(2:14,1:5),1)/sqrt(size(N_APs.MDM_55_Burst(2:14,1:5),1)))
% legend({'MDL 55mV','MDM 55mV burst'})

figure
subplot(1,2,1)
hold on
errorbar(I_input.MDL_70_SteadyState(11,1:5),mean([N_APs.MDL_70_SteadyState(11:17,1:5); N_APs.MDL_70_SteadyState(3:10,[1 4 8 11 14])],1),std([N_APs.MDL_70_SteadyState(11:17,1:5); N_APs.MDL_70_SteadyState(3:10,[1 4 8 11 14])],1)/sqrt(size([N_APs.MDL_70_SteadyState(11:17,1:5); N_APs.MDL_70_SteadyState(3:10,[1 4 8 11 14])],1)))
errorbar(I_input.MDM_70_SteadyState(1,1:5),mean([N_APs.MDM_70_SteadyState(1:15,1:5); N_APs.MDM_70_SteadyState([16],[1 4 8 11 14])],1),std([N_APs.MDM_70_SteadyState(1:15,1:5); N_APs.MDM_70_SteadyState([16],[1 4 8 11 14])],1)/sqrt(size([N_APs.MDM_70_SteadyState(1:15,1:5); N_APs.MDM_70_SteadyState([16],[1 4 8 11 14])],1)))
legend({'MDL 70mV','MDM 70mV steady state'})

% subplot(1,2,2)
% hold on
% errorbar(I_input.MDL_55_SteadyState(11,1:5),mean([N_APs.MDL_55_SteadyState(11:17,1:5); N_APs.MDL_55_SteadyState(3:10,[1 4 8 11 14])],1),std([N_APs.MDL_55_SteadyState(11:17,1:5); N_APs.MDL_55_SteadyState(3:10,[1 4 8 11 14])],1)/sqrt(size([N_APs.MDL_55_SteadyState(11:17,1:5); N_APs.MDL_55_SteadyState(3:10,[1 4 8 11 14])],1)))
% errorbar(I_input.MDM_55_SteadyState(1,1:5),mean([N_APs.MDM_55_SteadyState(1:14,1:5); N_APs.MDM_55_SteadyState([15 16 19 20],[1 4 8 11 14])],1),std([N_APs.MDM_55_SteadyState(1:14,1:5); N_APs.MDM_55_SteadyState([15 16 19 20],[1 4 8 11 14])],1)/sqrt(size([N_APs.MDM_55_SteadyState(1:14,1:5); N_APs.MDM_55_SteadyState([15 16 19 20],[1 4 8 11 14])],1)))
% legend({'MDL 55mV','MDM 55mV'})

MDL_SS = [N_APs.MDL_70_SteadyState(11:17,1:5); N_APs.MDL_70_SteadyState(3:10,[1 4 8 11 14])];
MDM_SS = [N_APs.MDM_70_SteadyState(1:15,1:5); N_APs.MDM_70_SteadyState([16],[1 4 8 11 14])];

MDL_Burst = [N_APs.MDL_70_Burst(11:17,1:5); N_APs.MDL_70_Burst(3:10,[1 4 8 11 14])];
MDM_Burst = [N_APs.MDM_70_Burst(1:15,1:5); N_APs.MDM_70_Burst([16],[1 4 8 11 14])];

for i = 2:5
    [MD_Burst.p(i), l, MD_Burst.stats(i)] = ranksum(MDL_Burst(:,i),MDM_Burst(:,i));
end
MD_Burst.p = mafdr(MD_Burst.p(2:5),'BHFDR','true');

for i = 2:5
    [MD_SS.p(i), l, MD_SS.stats(i)] = ranksum(MDL_SS(:,i),MDM_SS(:,i));
end
MD_SS.p = mafdr(MD_SS.p(2:5),'BHFDR','true');

[I_input.VS_70, N_APs.VS_70] = Step_prot_firing(VS_TABLE.Step70Pos_VS,'Str');
[I_input.DS_70, N_APs.DS_70] = Step_prot_firing(DS_TABLE.Step70Pos_DS,'Str');

figure
hold on
errorbar(I_input.VS_70(1,1:5),mean(N_APs.VS_70(:,1:5),1),std(N_APs.VS_70(:,1:5),1)/sqrt(size(N_APs.VS_70(:,1:5),1)))
errorbar(I_input.DS_70(1,1:5),mean(N_APs.DS_70(:,1:5),1),std(N_APs.DS_70(:,1:5),1)/sqrt(size(N_APs.DS_70(:,1:5),1)))
legend({'VS 70mV','DS 70mV'})

DS_APs = N_APs.DS_70(:,1:5);
VS_APs = N_APs.VS_70(:,1:5);

for i = 2:5
    [Str_APs.p(i), l, Str_APs.stats(i)] = ranksum(DS_APs(:,i),VS_APs(:,i));
end
Str_APs.p = mafdr(Str_APs.p(2:5),'BHFDR','true');

%% Subtreshold membrane resonance

% Do analysis
[Resonance_MDL_70 Q_fact_MDL_70] = Resonance(MDL_TABLE.CHIRP70_MDL,'MD');
[Resonance_MDM_70 Q_fact_MDM_70] = Resonance(MDM_TABLE.CHIRP70_MDM,'MD');
[Resonance_MDL_55 Q_fact_MDL_55] = Resonance(MDL_TABLE.CHIRP55_MDL,'MD');
[Resonance_MDM_55 Q_fact_MDM_55] = Resonance(MDM_TABLE.CHIRP55_MDM,'MD');

figure
subplot(1,2,1)
Reso = [Resonance_MDL_70 Resonance_MDM_70];
ResonanceGroups = [zeros(1,size(Resonance_MDL_70,2)),ones(1,size(Resonance_MDM_70,2))];
boxplot(Reso,ResonanceGroups,'Labels',{'MDL','MDM'})
[pRes,hRes,statsRes] = ranksum(Resonance_MDL_70,Resonance_MDM_70);
hold on
scatter(ones(size(Resonance_MDL_70)).*(1+(rand(size(Resonance_MDL_70))-0.5)/10),Resonance_MDL_70,10,'r','filled')
scatter(ones(size(Resonance_MDM_70)).*(2+(rand(size(Resonance_MDM_70))-0.5)/10),Resonance_MDM_70,10,'r','filled')
title('Resonance 70(MOhm)')
subplot(1,2,2)
Reso = [Resonance_MDL_55 Resonance_MDM_55];
ResonanceGroups = [zeros(1,size(Resonance_MDL_55,2)),ones(1,size(Resonance_MDM_55,2))];
boxplot(Reso,ResonanceGroups,'Labels',{'MDL','MDM'})
hold on
scatter(ones(size(Resonance_MDL_55)).*(1+(rand(size(Resonance_MDL_55))-0.5)/10),Resonance_MDL_55,10,'r','filled')
scatter(ones(size(Resonance_MDM_55)).*(2+(rand(size(Resonance_MDM_55))-0.5)/10),Resonance_MDM_55,10,'r','filled')
title('Resonance 55(MOhm)')

Resonance_VS_70 = Resonance(VS_TABLE.CHIRP70_VS,'Str');
Resonance_DS_70 = Resonance(DS_TABLE.CHIRP70_DS,'Str');

figure
Reso = [Resonance_VS_70 Resonance_DS_70];
ResonanceGroups = [zeros(1,size(Resonance_VS_70,2)),ones(1,size(Resonance_DS_70,2))];
boxplot(Reso,ResonanceGroups,'Labels',{'VS','DS'})
[pRes,hRes,statsRes] = ranksum(Resonance_VS_70,Resonance_DS_70);
hold on
scatter(ones(size(Resonance_VS_70)).*(1+(rand(size(Resonance_VS_70))-0.5)/10),Resonance_VS_70,10,'r','filled')
scatter(ones(size(Resonance_DS_70)).*(2+(rand(size(Resonance_DS_70))-0.5)/10),Resonance_DS_70,10,'r','filled')
title('Resonance 70(MOhm)')

