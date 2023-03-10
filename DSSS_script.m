%% Projet S8 

clear;
clc;
close all;

%% Parametres
N = 2^3;                                                      % Nombre de bits 
B = 22e3;                                                     % Largeur de bande du signal
fe = 50e3;                                                    % Fréquence d'échantillonage
roll_off = 0.5;                                               % facteur de roll-off

%% Tx
s = DSSS(N,B,fe,roll_off);

%% figures

figure,
plot(s)