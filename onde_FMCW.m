clc, 
clear, 
close all,

%% CM
fs = 100000; % fréquence d'échantillonnage
t = 0:1/fs:1-1/fs; % vecteur de temps
f = 1000; % fréquence du signal CW
A = 1; % amplitude du signal CW
signal1 = A*sin(2*pi*f*t); % signal CW

% Affichage du signal
figure, 
plot(t, signal1);
xlabel('Temps (s)');
ylabel('Amplitude');
xlim([0 0.02])
ylim([-2 2])
title('Signal CW');

%% Densité spectrale de puissance
[psd, f] = pwelch(signal1, [], [], [], fs);
figure,
plot(f, 10*log10(psd));
xlabel('Fréquence (Hz)');
ylabel('Densité spectrale de puissance (dB/Hz)');
title('DSP du signal CW');

%% Transformée de fourrier

Y = fft(signal1);
L = length(signal1);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(L/2))/L;

figure,
plot(f, P1);
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
title('Transformée de Fourier du signal CW généré sur MATLAB');

%% CMWF
f0 = 50; % fréquence initiale
f1 = 1000; % fréquence finale
signal2 = chirp(t, f0, 1, f1, 'linear'); % signal CWFM

% Affichage du signal
figure,
plot(t, signal2);
xlabel('Temps (s)');
xlim([0 0.2])
ylim([-1.5 1.5])
title('Signal Radar CWFM');
