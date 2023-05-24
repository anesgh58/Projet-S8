clear;
close all;
clc;

addpath("C:\Users\cleme\Documents\MATLAB\Examples\R2022a\deeplearning_shared\ModulationClassificationWithDeepLearningExample")

modulationTypes = categorical(["BPSK", "QPSK", "8PSK", "16QAM", "64QAM", "PAM4", "GFSK", "CPFSK", "B-FM", "DSB-AM", "SSB-AM"]);

load trainedModulationClassificationNetwork
trainedNet

% Set the random number generator to a known state to be able to regenerate
% the same frames every time the simulation is run
rng(123456)


fe = 10e3;
fs = 1000;
Ns = 10000;
M = 64;
filtre = "cosinus surélevé";
SNR = 10;
[sb_bin, y] = func_PSK_bdb(fe, fs, Ns, M, filtre, SNR);


[sb_bin1, y1]= func_QAM_bdb(fe, fs, Ns, M, filtre, SNR);

fc0 = 1000;
fc1 = 2000;
T_i = 0;
T_f = 500e-3;
Ns = round((T_f-T_i)*fe);
[sb_bin2, y2]= func_FSK(fe, fs, T_i, T_f, fc0,fc1, filtre, SNR);

% Frame generation for classification
unknownFrames = helperModClassGetNNFrames(y.');

% Classification
[prediction1,score1] = classify(trainedNet,unknownFrames);
prediction1

% Frame generation for classification
unknownFrames = helperModClassGetNNFrames(y1.');

% Classification
[prediction2,score2] = classify(trainedNet,unknownFrames);
prediction2

% Frame generation for classification
unknownFrames = helperModClassGetNNFrames(y2.');

% Classification
[prediction3,score3] = classify(trainedNet,unknownFrames);
prediction3


