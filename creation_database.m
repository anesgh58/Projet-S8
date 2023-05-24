clear;
close all;
clc;

fe = 10e3;
fs = 1000;
Ns = 100;
M = 8;
filtre = "cosinus surélevé";

nb_signaux = 2000;
Fse = fe/fs;

signals_1 = zeros(nb_signaux,Ns*Fse);
signals_2 = zeros(nb_signaux,Ns*Fse);
signals_3 = zeros(nb_signaux,Ns*Fse);
signals_4 = zeros(nb_signaux,Ns*Fse);
%signals_5 = zeros(nb_signaux/10,10001);
%signals_6 = zeros(nb_signaux/10,10001);


SNR = repelem(11:30, 100);

tic
for i=1:nb_signaux
    [~, signals_1(i,:)] = func_MPSK_bdb(fe, fs, Ns, M, filtre, SNR(i));
end
writematrix(signals_1,"data/1/signals.csv");

for i=1:nb_signaux
    [~, signals_2(i,:)]= func_ASK_bdb(fe, fs, Ns, filtre, SNR(i));
end
writematrix(signals_2,"data/2/signals.csv");

for i=1:nb_signaux
    [~, signals_3(i,:)]= func_MQAM_bdb(fe, fs, Ns, 64, filtre, SNR(i));
end
writematrix(signals_3,"data/3/signals.csv");

for i=1:nb_signaux
    [~, signals_4(i,:)]= func_FSK_bdb(fe, fs, Ns, 1000, 2000, filtre, SNR(i));
end
writematrix(signals_4,"data/4/signals.csv");
toc

%{
Te = 4e-9;
T_i = 20e-6;
T_f = 60e-6;
f = 10e3;

for i=1:nb_signaux/10
    [signals_5(i,:), ~] = CW(T_i,T_f,Te,f);
end
writematrix(signals_5,"data/5/signals.csv");

f = 10; % Fréquence initiale en Hz
B = 10+50e6; % Bande passante en Hz
T = 40e-6; % Durée de l'impulsion en secondes
Te = 4e-9; % Temps d'échantillonage
T_i2 = 40e-6;
T_f2 = 80e-6;

for i=1:nb_signaux/10
    [signals_6(i,:), ~] = FMCW(T_i2,T_f2, Te, B , f);
end
writematrix(signals_6,"data/6/signals.csv");
toc

Te = 4e-9;
T_i = 20e-6;
T_f = 60e-6;
f = 10e3;

[signal_test, ~]= CW(T_i,T_f,Te,f);
writematrix(signal_test,"test/signal.csv");
%}


