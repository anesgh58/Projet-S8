close all,
clc,
clear,

%% Signal CM
Te = 4e-11;
T_i = 20e-6;
T_f = 60e-6;
[s1,t1] = CW(T_i,T_f, Te) ;



% Tracé du signal CW
figure,
plot(t1, s1);
xlim([0 10e-8]);

xlabel('Temps (s)');
ylabel('Amplitude');
title('Signal CW');
%%
% Définition des paramètres du spectrogramme
window_length = round(length(s1)/10); % Longueur de la fenêtre
noverlap = round(window_length/2); % Chevauchement des fenêtres

% Calcul du spectrogramme
figure,
spectrogram(s1, window_length, noverlap, [], 1/Te, 'yaxis');


%% FMCW 
% Définition des paramètres du signal
f = 10; % Fréquence initiale en Hz
B = 10+50e6; % Bande passante en Hz
T = 40e-6; % Durée de l'impulsion en secondes
Te = 4e-11; % Temps d'échantillonage
T_i2 = 40e-6;
T_f2 = 80e-6;
[s,t] = FMCW(T_i2,T_f2, Te, B , f);



% Tracé du signal FMCW
figure;
plot(t, s);

xlabel('Temps (s)');
xlim([0 1.5e-6])
ylabel('Amplitude');
title('Signal FMCW');

%%
% Calcul de la fréquence instantanée
f_inst = f + B*t/T;

% Tracé de la fréquence en fonction du temps
figure;
plot(t, f_inst);
xlabel('Temps (s)');
ylabel('Fréquence (Hz)');
title('Fréquence instantanée');


% Calcul de la FFT du signal FMCW
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


%% Figures 

figure,
A = zeros(1,100e5);
A(:,T_i/Te:T_f/Te) = s1;
C = zeros(1,100e5);
C(:,T_i2/Te:T_f2/Te) = s;
spectrogram(A+C, window_length, noverlap, [], 1/Te, 'yaxis');
[spe,f,t, pxx] = spectrogram(A+C, window_length, noverlap, [], 1/Te, 'yaxis');
xlim([0 100])
ylim([0 0.2])
figure(10),
imagesc(t,f,pow2db(flipud(pxx))>75)

