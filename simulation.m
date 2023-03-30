clear;
close all;
clc;

%% Parametres

n=2;                                                          % nombre de signaux a generer

% Signaux numeriques
% DSSS
N_1 = 2^10;                                                   % Nombre de bits 
B_1 = 22e3;                                                   % Largeur de bande du signal
fe_1 = 50e3;                                                  % Fréquence d'échantillonage
roll_off = 0.5;                                               % Facteur de roll-off
Nfft = N_1;                                                   % Nombre de point dans la FFT 
% f = fe/Nfft * (0:(Nfft-1)) - fe/2 ;                         % Axe des fréquentiel
fc_1 = 20*10^4;

% Signaux analogiques
% onde FM
Am=1;
Fm=1*10^3;
Ap=1;
k=0.5;
Fp=10*10^3;
OSR=4;
N_2=10000;
Fmax=10*10^3;
Fs=Fmax*2^OSR;
Ts=1/Fs;
t= (1:N_2)*Ts;
%Modulation
m=Am*cos(2*pi*Fm*t);
%Porteuse
p=Ap*cos(2*pi*Fp*t);
fe_2 = 50e3;
fc_2 = Fp;

% Signaux radars
% CW
Te_3 = 4e-8;
fe_3 = 1/Te_3;
T_i = 20e-6;
T_f = 60e-6;
fc_3 = 60*10e5;

% FMCW 
% Définition des paramètres du signal
f_4 = 10;     % Fréquence initiale en Hz
B_4 = 10+250e6; % Bande passante en Hz
T_4 = 40e-6; % Durée de l'impulsion en secondes
Te_4 = T_4*1e-5; % Temps d'échantillonage
fe_4 = 1/Te_4;
fc_4 = f_4;


%% Signaux
fe_s = [fe_1, fe_2,fe_3,fe_4];
fc = [fc_1, ones(1,4)* fc_2,fc_3,fc_4];
fe = min(fe_s); % Suréchantillonnage

%% Generation des signaux et suréchantillonnage au rythme fe
[~,~,signal_1] = DSSS(N_1,B_1,fe_1,roll_off);                                    % DSSS
signal_1 = upsample(signal_1,floor(fe/fe_s(1))); 
signal_2 = upsample(onde_FM(m,Am,Fm,k,p,Ap,Fp,OSR),floor(fe/fe_s(2))+1);         % FM
signal_3 = upsample(onde_AM(m,Fm,k,p,Ap,Fp,OSR,'DBAP'),floor(fe/fe_s(2))+1);     % AM
signal_4 = upsample(onde_PM(m,Fm,Am,p,Ap,Fp,OSR,5),floor(fe/fe_s(2))+1);         % PM
signal_5 = upsample(radar_pulse(100,10000,Fp,OSR,5),floor(fe/fe_s(2))+1);        % radar
[signal_6,~] = CW(T_i,T_f, Te_3);                                                % CW
signal_6 = upsample(signal_6,floor(fe/fe_s(3))+1) ;                                
[signal_7,~] = FMCW(T_i,T_f,  Te_4, B_4, f_4);                                   % FMCW
signal_7= upsample(signal_7,floor(fe/fe_s(4))+1);  

%% Interpolation linéaire
signal_1 = interpolation(signal_1);
signal_2 = interpolation(signal_2);
signal_3 = interpolation(signal_3);
signal_4 = interpolation(signal_4);
signal_5 = interpolation(signal_5);
signal_6 = interpolation(signal_6);
signal_7 = interpolation(signal_7);


%% Decalage de chaque signal par rapport a l'instant de debut et stockage
% dans les colonnes d'une matrice

len = max([length(signal_1),length(signal_2),length(signal_3),length(signal_4),length(signal_5),length(signal_6),length(signal_7)]);
time = randi([1, 5000], 1, n); % Generer n instants de debuts differents

signaux = zeros(len,1);
signaux(time(1):length(signal_1)+time(1)-1,1) = signal_1;
signaux(time(2):length(signal_2)+time(2)-1,2) = signal_2;
% signaux(time(3):length(signal_3)+time(3)-1,3) = signal_3;
% signaux(time(4):length(signal_4)+time(4)-1,4) = signal_4;
% signaux(time(5):length(signal_5)+time(5)-1,5) = signal_5;
% signaux(time(6):length(signal_6)+time(6)-1,6) = signal_6;
% signaux(time(7):length(signal_7)+time(7)-1,7) = signal_7;
signaux = signaux(1:len,:);


%% Multiplication de chaque signal par PTX
PRx = zeros(1,n);
PTX = randi([10e3, 50e5],1,n);
B = 2 * fe;
coord_sat = [randi([1000 2000],1), randi([0 360],1), randi([0 90],1)];
temperatures = [150, -120];
idx = randi([1,2]);
To = temperatures(idx);
coord_terre = zeros(3,n);
for i=1:n
    coord_terre(:,i) = [randi([30 60],1), randi([0 360],1), randi([0 90],1)];
    PRx(i) = Puissance_generator(PTX(i), fc(i),B,coord_sat,coord_terre(:,i),To);
end
signaux = signaux .* PRx;
% signaux(:,5) = 10 * signaux(:,5);

%% signal recu
signal_recu = zeros(len,1);
% signal recu
for i=1:n
    signal_recu = signal_recu + signaux(:,i); 
end

% signal_recu = signal_recu>0;
figure, plot(signal_recu)

%% spectrogramme

% Définition des paramètres du spectrogramme
window_length = round(length(signal_recu) /100); % Longueur de la fenêtre
noverlap = round(window_length/2); % Chevauchement des fenêtres

[spect,f,t] = spectrogram(signal_recu, window_length, noverlap, [], fe, 'yaxis');
imagesc(t, f, 20*log10(abs(spect)));
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;

%% Binarisation


%% figure

[pho_DSSS,Lc_est_DSSS] = DSSS_detection(signal_recu);    % Détection d'un signal DSSS emis seul

figure,
plot(pho_DSSS)
xlabel('Échantillons')
ylabel('Amplitude')
title("Détection d'un signal DSSS emis seul")


