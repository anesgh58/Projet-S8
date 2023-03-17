close all,
clc,
clear,

%% Signal CM
T = 1; % Durée du signal
Te = 0.001; % Temps d'échantillonage
t1 = 0:Te:T; % Vecteur de temps
f = 10; % fréquence du signal CW
A = 1; % amplitude du signal CW
s1 = A*cos(2*pi*f*t1); % signal CW

% Tracé du signal CW
figure,
plot(t1, s1);
xlabel('Temps (s)');
ylabel('Amplitude');
title('Signal CW');

% Définition des paramètres du spectrogramme
window_length = round(length(s1)/10); % Longueur de la fenêtre
noverlap = round(window_length/2); % Chevauchement des fenêtres

% Calcul du spectrogramme
spectrogram(s1, window_length, noverlap, [], 1/Te, 'yaxis');


%% FMCW 
% Définition des paramètres du signal
f = 10; % Fréquence initiale en Hz
B = 10+150e6; % Bande passante en Hz
T = 1; % Durée de l'impulsion en secondes
Te = 1e-3; % Temps d'échantillonage
t = 0:Te:T; % Vecteur de temps

% Calcul du signal FMCW
s = cos(2*pi*(f*t + B*(t.^2)/(2*T)));

% Tracé du signal FMCW
figure;
plot(t, s);
xlabel('Temps (s)');
ylabel('Amplitude');
title('Signal FMCW');

% Calcul de la fréquence instantanée
f_inst = f + B*t/T;

% Tracé de la fréquence en fonction du temps
figure;
plot(t, f_inst);
xlabel('Temps (s)');
ylabel('Fréquence (Hz)');
title('Fréquence instantanée');


% Calcul de la FFT du signal FMCW
%fs = 1/(t(2)-t(1)); % Fréquence d'échantillonnage
fs = 1/Te;
nfft = length(s); % Longueur de la FFT
S = fft(s, nfft)/nfft; % FFT normalisée
freq = linspace(-fs/2, fs/2, nfft); % Vecteur de fréquences

% Tracé du module de la FFT
figure;
plot(freq, abs(fftshift(S)));
xlabel('Fréquence (Hz)');
ylabel('Module de la FFT');
title('FFT du signal FMCW');

% Définition des paramètres du spectrogramme
window_length = round(length(s)/10); % Longueur de la fenêtre
noverlap = round(window_length/2); % Chevauchement des fenêtres

% Calcul du spectrogramme
spectrogram(s, window_length, noverlap, [], 1/Te, 'yaxis');

