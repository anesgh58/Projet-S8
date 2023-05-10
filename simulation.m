function [signal_recu,signaux,fe] = simulation(n,Tbuffer)

%% Parametres

% Signaux numeriques
% DSSS
N_1 = 2^9;      % Nombre de bits 
fe_1 = 50e6;    % Fréquence d'échantillonage
B_1 = 1e6;      % Largeur de bande du signal
roll_off = 0.5; % Facteur de roll-off
fc_1 = 1e6;     % Fréquence de porteuse

% Signaux analogiques

%Donnees modulant
Am=1;
Fm=1*10^2;
Ap=1;
k=0.5;

%Onde FM
Fp_FM=3.5e6;
fe_2=4*Fp_FM;
Tf_2 = 120e-3;
Ti_2 = 80e-3;
Te_2 = 1/fe_2; % Temps d'échantillonage
fc_2 = Fp_FM;

% Onde AM
Fp_AM=12.5e6;
fe_3=4*Fp_AM;
Tf_3 = 75e-3;
Ti_3 = 50e-3;
Te_3 = 1/fe_3; % Temps d'échantillonage
fc_3 = Fp_AM;

% Onde PM
kf=5;
Fp_PM=10e6;
fe_4=4*Fp_PM;
Tf_4 = 175e-3;
Ti_4 = 150e-3;
Te_4 = 1/fe_4; % Temps d'échantillonage
fc_4 = Fp_PM;

% Signaux radars
% Radar à pulsation
Fp_RadarPulse=10*10^6;
fe_5=4*Fp_RadarPulse;
durpulse=10e-3;
durect=50e-3;
Tf_5 = 200e-3;
Ti_5 = 150e-3;
Te_5 = 1/fe_5; % Temps d'échantillonage
fc_5 = Fp_RadarPulse;

% CW
Te_6 = 2.2e-8;
fe_6 = floor(1/Te_6);
T_i = 20e-6;
T_f = 100e-6;
fc_6 = 16e6;

% FMCW 
% Définition des paramètres du signal
f_7 = 3e6;     % Fréquence initiale en Hz
B_7 = 1e6; % Bande passante en Hz
T_7 = 2.5e-6; % Durée de l'impulsion en secondes
Te_7 = T_7*1e-2; % Temps d'échantillonage
fe_7 = floor(1/Te_4);
fc_7 = f_7;

fe_s = [fe_1, fe_2,fe_3,fe_2,fe_4,fe_5,fe_6,fe_7];
fc = [fc_1, fc_2,fc_3,fc_2,fc_4,fc_5,fc_6,fc_7];
fe = 50e6;                               % fréquence d'échantillonnage
len = Tbuffer * fe;                      % durée du signal d'enregistrement (en nombre d'échantillons)
time = randi([1, round(len*0.3)], 1, n); % Temps d'émission
PTX = randi([60e5, 65e5],1,n);           % Puissance d'émission
B = fe;                                  % Bande passante en bande de base
temperatures = [150, -120];              % Température de surface du satellite
idx = randi([1,2]);
To = temperatures(idx);                  % Choix de le température

% coordonnées des émetteurs et récepteur
coord_sat = [550000 46.103 2.6492];
altitude_Tx = randi([0 500],1,n);
longitude_Tx = randi([0 7],1,n);
latitude_Tx = randi([42 51],1,n);
coord_Tx = [altitude_Tx;longitude_Tx;latitude_Tx];

% Puissance de réception des signaux
for i=1:n
PRx(i) = Puissance_generator(PTX(i), fc(i),B,coord_sat,coord_Tx(:,i),To);
end
PRx(:,1) = PRx(:,1) * 5;
PRx(:,5) = PRx(:,5) * 10;

%% Génération  des signaux et suréchantillonnage au rythme fe

[signal_1,~,~] = DSSS(N_1,B_1,fe_1,roll_off);                           % DSSS
[signal_1] = upscale(signal_1,fe,fe_s(1),len, time(1),PRx(1));

signal_2 = onde_FM(Am,Fm,k,Ap,Fp_FM,Ti_2,Tf_2,Te_2);
N = 50;
h_pass = fir1(N,0.2,'low',hamming(N+1));    % Filtre passe bas
signal_2 = conv(signal_2,h_pass);
signal_2 = upscale(signal_2,fe,fe_s(2),len, time(2),PRx(2));

signal_3 = onde_AM(Fm,Am,k,Fp_AM,Ap,Tf_3,Ti_3,Te_3,'DBAP');              % AM
signal_3 = upscale(signal_3,fe,fe_s(3),len, time(3),PRx(3));

signal_4 = onde_PM(Fm,Am,Ap,Fp_PM,Tf_4,Ti_4,Te_4,kf);                    % PM
signal_4 = upscale(signal_4,fe,fe_s(4),len, time(4),PRx(4));

signal_5 = radar_pulse(durpulse,durect,Tf_5,Ti_5,Te_5,Fp_RadarPulse);
signal_5 = upscale(signal_5,fe,fe_s(5),len, time(5),PRx(5));

[signal_6,~] = CW(T_i,T_f, Te_6);                                        % CW
signal_6 = upscale(signal_6,fe,fe_s(6),len, time(6),PRx(6));   

[signal_7,~] = FMCW(T_i,T_f,  Te_7, B_7, f_7);                           % FMCW
signal_7 = upscale(signal_7,fe,fe_s(7),len, time(7),PRx(7)); 

%% Stockage des signaux générés dans une matrice
signaux = zeros(int32(len),n);
signaux(:,1) = signal_1;
signaux(:,2) = signal_2;
signaux(:,3) = signal_3;
signaux(:,4) = signal_4;
signaux(:,5) = signal_5;
signaux(:,6) = signal_6;
signaux(:,7) = signal_7;
  
%% signal recu
signal_recu = sum(signaux) ;

end



