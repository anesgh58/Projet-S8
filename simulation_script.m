clear;
close all;
clc;

%% Génération  du stimuli
n=7;
Tbuffer = 1.45e-6;
[signal_recu,signaux,fe] = simulation(n,Tbuffer);
bruit = randn(1,round(Tbuffer*fe));

%% spectrogramme
% Définition des paramètres du spectrogramme
window_length = round( ( length(signaux(:,1)) +length(signaux(:,6)) + length(signaux(:,7))   ) /100); % Longueur de la fenêtre
noverlap = round(window_length/2);               % Chevauchement des fenêtres
test_signal = signaux(:,1) + signaux(:,6) + signaux(:,7) + bruit.'   ;
[spect,f,t,pxx] = spectrogram(test_signal, window_length, noverlap, [], fe, 'yaxis');

spectrogram(test_signal, window_length, noverlap, [], fe, 'yaxis');
title('Spectrogramme du signal reçu')

%% Binarisation
spect_binarise = pow2db(pxx)<5;

figure,
imagesc(t,f,spect_binarise)
colormap("gray");
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;
title('Spectrogramme du signal binarisé')

%% Filtres passe bandes et classification
%% DSSS
% filtre
bandwidth = 1.5e9 - 0.9e9;
center_freq = 0.8e9;
filtered_signal = pass_filter(test_signal,bandwidth,center_freq,fe);

% Spectrogramme du signal filtré
window_length = round((length(filtered_signal)) /100);            % Longueur de la fenêtre
noverlap = round(window_length/2);  
[spect,f,t,pxx_DSSS] = spectrogram(filtered_signal, window_length, noverlap, [], fe, 'yaxis');

figure,
imagesc(t,f,flipud(pxx_DSSS))
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;
title('Spectrogramme du signal reçu filtré (DSSS)')

% Classification
[pho_DSSS,Lc_DSSS] = DSSS_detection(signaux(:,1));             % Détection d'un signal DSSS émis seul
[pho_est_DSSS,Lc_est_DSSS] = DSSS_detection(filtered_signal);  % Détection d'un signal DSSS 
if ( (0.85 * Lc_DSSS  <= Lc_est_DSSS) && (Lc_est_DSSS <= 1.5 * Lc_DSSS))
    disp('Modulation detectee: DSSS');
end

% figures
figure,
subplot(1,2,1)
plot(pho_DSSS)
xlabel('Échantillons')
ylabel('Amplitude')
title("Détection d'un signal DSSS émis seul")

subplot(1,2,2)
plot(pho_est_DSSS)
xlabel('Échantillons')
ylabel('Amplitude')
title("Détection d'un signal DSSS au sein du signal d'enregistrement")

figure,
subplot(1,2,1)
plot(signaux(:,1))
xlabel('Temps')
ylabel('Amplitude')
title("Évolution temporel du signal DSSS émis seul")

subplot(1,2,2)
plot(filtered_signal)
xlabel('Temps')
ylabel('Amplitude')
title("Évolution temporel du signal DSSS après filtrage")

%% Autre modulation 







