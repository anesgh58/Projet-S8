clear;
close all;
clc;

%% Parametres

n=7;                                                          % nombre de signaux a generer
fe_s = [];

% Signaux numeriques
% DSSS
N_1 = 2^10;                                                   % Nombre de bits 
B_1 = 22e3;                                                     % Largeur de bande du signal
fe_1 = 50e3;                                                  % Fréquence d'échantillonage
roll_off = 0.5;                                               % Facteur de roll-off
Nfft = N_1;                                                     % Nombre de point dans la FFT 
% f = fe/Nfft * (0:(Nfft-1)) - fe/2 ;                         % Axe des fréquentiel

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

% Signaux radars
% CW
Te_3 = 4e-8;
fe_3 = 1/Te_3;
T_i = 20e-6;
T_f = 60e-6;

% FMCW 
% Définition des paramètres du signal
f_4 = 10;     % Fréquence initiale en Hz
B_4 = 10+250e6; % Bande passante en Hz
T_4 = 40e-6; % Durée de l'impulsion en secondes
Te_4 = T_4*1e-5; % Temps d'échantillonage
fe_4 = 1/Te_4;


%% Signaux
fe_s = [fe_1, fe_2,fe_3,fe_4];
fe = min(fe_s); % Suréchantillonnage

% Generation des signaux et suréchantillonnage au rythme fe
[~,~,signal_1] = DSSS(N_1,B_1,fe_1,roll_off);                                    % DSSS
signal_1 = upsample(signal_1,floor(fe/fe_s(1))); 
signal_2 = upsample(onde_FM(m,Am,Fm,k,p,Ap,Fp,OSR),floor(fe/fe_s(2))+1);           % FM
signal_3 = upsample(onde_AM(m,Fm,k,p,Ap,Fp,OSR,'DBAP'),floor(fe/fe_s(2))+1);       % AM
signal_4 = upsample(onde_PM(m,Fm,Am,p,Ap,Fp,OSR,5),floor(fe/fe_s(2))+1);           % PM
signal_5 = upsample(radar_pulse(100,10000,Fp,OSR,5),floor(fe/fe_s(2))+1);          % radar
[signal_6,~] = CW(T_i,T_f, Te_3);                                                % CW
signal_6 = upsample(signal_6,floor(fe/fe_s(3))+1) ;                                
[signal_7,~] = FMCW(T_i,T_f,  Te_4, B_4, f_4);                                   % FMCW
signal_7= upsample(signal_7,floor(fe/fe_s(4))+1);     

% signal_1_interp = interpolation(signal_1);

% Les signaux sont stockés les colonnes de la matrice signaux
len = max([length(signal_1),length(signal_2),length(signal_3),length(signal_4),length(signal_5),length(signal_6),length(signal_7)]);
signaux = zeros(len,1);
signaux(1:length(signal_1),1) = signal_1;
signaux(1:length(signal_2),2) = signal_2;
signaux(1:length(signal_3),3) = signal_3;
signaux(1:length(signal_4),4) = signal_4;
signaux(1:length(signal_5),5) = signal_5;
signaux(1:length(signal_6),6) = signal_6;
signaux(1:length(signal_7),7) = signal_7;

% Interpolation linéaire
signal_recu = zeros(len,1);
for i=1:n
    signaux(:,i) = interpolation(signaux(:,i).');
end


% Calcul de PRx de chaque signal

PRx = [];
PTX=randi([10e3, 50e5], 1, n);
for i=1:n
    PRx = [PRx puissance_generateur(PTX, F, B,coord_sat,coord_terre)];
end
%PTX(:,5)=PTX(:,5)*10;
signaux = signaux .* PRx;

% Generer n instants de debuts differents
time = randi([1, 50], 1, n);

% decaage de chaque signal par rapport a l'instant de debut

% signal recu
for i=1:n
    signal_recu = signal_recu + signaux(:,i); 
end


%% figure

% Définition des paramètres du spectrogramme
window_length = round(length(signal_recu)/100); % Longueur de la fenêtre
noverlap = round(window_length/2); % Chevauchement des fenêtres

% Calcul du spectrogramme
spectrogram(signaux(:,6) + signaux(:,7), noverlap, [], fe, 'yaxis');





