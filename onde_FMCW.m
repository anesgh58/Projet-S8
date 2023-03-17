close all,
clc,
clear,

%% Signal CM
Te = 4e-8;
T_i = 20e-6;
T_f = 60e-6;
[s1,t1] = CW(T_i,T_f, Te) ;



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
figure,
spectrogram(s1, window_length, noverlap, [], 1/Te, 'yaxis');


%% FMCW 
% Définition des paramètres du signal
f = 10; % Fréquence initiale en Hz
B = 10+250e6; % Bande passante en Hz
T = 40e-6; % Durée de l'impulsion en secondes
Te = T*1e-5; % Temps d'échantillonage

[s,t] = FMCW(T_i,T_f, Te, B , f);



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
window_length = round(length(s)/100); % Longueur de la fenêtre
noverlap = round(window_length/2); % Chevauchement des fenêtres

% Calcul du spectrogramme
spectrogram(s, window_length, noverlap, [], 1/Te, 'yaxis');


%%

figure,
A = zeros(1,100001);
A(:,15000:15000+1000) = s1;


spectrogram(A+s, window_length, noverlap, [], 1/Te, 'yaxis');


%%%




