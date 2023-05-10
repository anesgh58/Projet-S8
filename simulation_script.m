clear;
close all;
clc;

%% Paramètres

n=7;                                      % Nombre de signaux à générer
Tbuffer = 500e-6;                         % Durée du signal d'enregistrement (en secondes)
seuil = 70;                               % Seuil énergétique

% filtrage
N = 50;                                    % Nombre de coefficients du filtre passe bas et passe haut
h_low = fir1(N,1/2,'low',hamming(N+1));    % Filtre passe bas
h_high = fir1(N,1/2,'high',hamming(N+1));  % Filtre passe haut
bandwith_signal = 0.6e6/25e6;              % Largeur de bande des signaux normalisée
B=1;                                       % Largeur de bande du filtre normalisée initiale
i=1;                                       % Initialisation du nombre d'itérations
signal_low_all = [];                       % Ensemble des signaux après filtrage passe bas et décimation lors de la dernière itération, stockés par colonne
signal_high_all = [];                      % Ensemble des signaux après filtrage passe haut et décimation lors de la dernière itération, stockés par colonne

%% Génération  du stimuli

[signal_recu,signaux,fe] = simulation(n,Tbuffer); % Génération du stimuli

%% spectrogramme

window_length = round((fe*Tbuffer)/100);                                             % Longueur de la fenêtre
noverlap = round(window_length/2);                                                   % Chevauchement des fenêtres
test_signal = awgn(signaux(:,1)+signaux(:,6)+signaux(:,7),100) ;
[spect,f,t,pxx] = spectrogram(test_signal, window_length, noverlap, [], fe, 'yaxis');

%% Binarisation
spect_binarise = pow2db(pxx)>seuil;

%% Identification des temps d'émission,temps de réception et fréquences porteuses

donnees = identification(spect_binarise,t,f); % Matrice contenant dans sa colonne la fréquence porteuse fp, temps d'émission Tx et temps de réception Tr. 


%% filtrage (filtre PB et PH + décimation)

[signaux_classifications,signal_low_all,signal_high_all] = filtrage(N,test_signal,B,h_low,h_high,bandwith_signal,i,signal_low_all,signal_high_all);

%% classification
% Entrée: donnees + signaux_classifications

%% Figures

% Spectrogramme du signal reçu
spectrogram(test_signal, window_length, noverlap, [], fe, 'yaxis');
title('Spectrogramme du signal reçu')

% Binarisation
figure,
imagesc(t,f,spect_binarise)
colormap("gray");
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;
title('Spectrogramme du signal binarisé')

% filtrage (filtre PB et PH + décimation)
figure,pwelch(nonzeros(signal_low_all(:,1)));
figure,pwelch(nonzeros(signal_high_all(:,3)));
figure,pwelch(nonzeros(signal_low_all(:,3)));
figure,pwelch(nonzeros(signal_high_all(:,7)));






