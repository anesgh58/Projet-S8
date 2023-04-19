%% Projet S8 
clear;
clc;
close all

%% Parametres
N = 2^10;                                                     % Nombre de bits 
B = 100e7;                                                     % Largeur de bande du signal
fe = 50e8;                                                    % Fréquence d'échantillonage
roll_off = 0.5;                                               % Facteur de roll-off

%% Tx
% DSSS
[yl,~,~] = DSSS(N,B,fe,roll_off);                             % Signal DSSS

% Modulation QPSK
sequence = randn(1,length(yl)) > 0;                           % Géneration d'une séquence binaire aléatoire
psk = pskmod(bi2de(sequence.'),4,pi/4).';                     % Modulation QPSK de la séquence binaire aléatoire

% Signal recu
signal_recu_DSSS = yl ;                                       % DSSS 
signal_recu_mixte = yl + psk;                                 % DSSS + QPSK   

%% DSSS detection
[pho_DSSS,Lc_est_DSSS] = DSSS_detection(signal_recu_DSSS);    % Détection d'un signal DSSS émis seul
[pho_mixte,Lc_est_mixte] = DSSS_detection(signal_recu_mixte); % Détection d'un signal DSSS émis avec d'autres signaux
% assert(Lc_est_DSSS == Lc_est_mixte);
%% Figures
% Moyenne des moments d’ordre 2 de la fonction d’autocorrélation des différents sous signaux

figure,
plot(pho_DSSS)
xlabel('Échantillons')
ylabel('Amplitude')
title("Détection d'un signal DSSS emis seul")

figure,
plot(pho_mixte)
xlabel('Échantillons')
ylabel('Amplitude')
title("Détection d'un signal DSSS émis avec d'autres signaux")