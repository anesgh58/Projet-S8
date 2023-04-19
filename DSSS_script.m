%% Projet S8 
clear;
clc;
close all;

%% Parametres
N = 2^10;                                                     % Nombre de bits 
B = 100e6;                                                    % Largeur de bande du signal
fe = 50e8;                                                     % Fréquence d'échantillonage
roll_off = 0.5;                                               % Facteur de roll-off
Nfft = N;                                                     % Nombre de point dans la FFT 
f = fe/Nfft * (0:(Nfft-1)) - fe/2 ;                           % Axe des fréquentiel
%% Tx
[s,ss,ss_spread] = DSSS(N,B,fe,roll_off);

% FFT du signal émis
s_fft = fftshift(abs(fft(s,Nfft)));
ss_fft = fftshift(abs(fft(ss,Nfft)));
ss_spread_fft = fftshift(abs(fft(ss_spread,Nfft)));

%% figures

% Visualtion des signaux dans le domaine temporel et frequentiel 

figure,
subplot(1,2,1)
plot(ss)
xlabel('Temps')
ylabel('Amplitude')
xlim([0 50])
title('Séquence binaire')

subplot(1,2,2)
% plot(f,ss_fft)
% xlabel('Fréquence (Hz)')
% ylabel('Amplitude')
% title('Tranformée de Fourier de la séquence binaire')
pwelch(ss, ones(1,length(ss)),0,length(ss),fe,'centered');

figure,
subplot(1,2,1)
plot(ss_spread)
xlabel('Temps')
ylabel('Amplitude')
xlim([0 50])
title('Signal étalé')

subplot(1,2,2)
% plot(f,ss_spread_fft)
% xlabel('Fréquence (Hz)')
% ylabel('Amplitude')
% title('Tranformée de Fourier du signal étalé')
pwelch(ss_spread, ones(1,length(ss)),0,length(ss),fe,'centered');

figure,
subplot(1,2,1)
plot(s)
xlim([0 100])
xlabel('Temps')
ylabel('Amplitude')
title('Signal suite à une modulation BPSK ')

subplot(1,2,2)
% plot(f,s_fft)
% xlabel('Fréquence (Hz)')
% ylabel('Amplitude')
% title('Tranformée de Fourier suite à une modulation BPSK')
pwelch(s, ones(1,length(ss)),0,length(ss),fe,'centered');



