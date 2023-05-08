function [signal_recu,signaux,fe] = simulation(n,Tbuffer)
    
% Signaux numeriques
% DSSS
N_1 = 2^9;                                                   % Nombre de bits 
fe_1 = 50e6;                                                   % Fréquence d'échantillonage
B_1 = 1e6;                                                  % Largeur de bande du signal
roll_off = 0.5;                                               % Facteur de roll-off
fc_1 = 1e6;

% Signaux analogiques
% onde FM
Am=1;
Fm=1*10^2;
Ap=1;
k=0.5;
Fp_AM=12.5e6;
Fp_FM=10e6;
OSR=2;
N_2=1000;
Fs_AM=Fp_AM*2^OSR;
Fs_FM=Fp_FM*2^OSR;
Ts_AM=1/Fs_AM;
Ts_FM=1/Fs_FM;
t_AM=(0:Ts_AM:(N_2-1)*Ts_AM);
t_FM=(0:Ts_FM:(N_2-1)*Ts_FM);
%Modulation
m_AM=Am*cos(2*pi*Fm*t_AM);
m_FM=Am*cos(2*pi*Fm*t_FM);
%Porteuse
p_AM=Ap*cos(2*pi*Fp_AM*t_AM);
p_FM=Ap*cos(2*pi*Fp_FM*t_FM);
fe_2 = Fs_FM;
fe_3 = Fs_AM;
fc_2 = Fp_FM;
fc_3 = Fp_AM;

% Signaux radars
Fp_RadarPulse=10*10^6;
fc_4 = Fp_RadarPulse;
fe_4=Fp_RadarPulse*2^OSR;

% CW
Te_3 = 2.2e-8;
fe_5 = floor(1/Te_3);
T_i = 20e-6;
T_f = 100e-6;
fc_5 = 16e6;


% FMCW 
% Définition des paramètres du signal
f_4 = 3e6;     % Fréquence initiale en Hz
B_4 = 1e6; % Bande passante en Hz
T_4 = 2.5e-6; % Durée de l'impulsion en secondes
Te_4 = T_4*1e-2; % Temps d'échantillonage
fe_6 = floor(1/Te_4);
fc_6 = f_4;


%% Signaux
fe_s = [fe_1, fe_2,fe_3,fe_2,fe_4,fe_5,fe_6];
fc = [fc_1, fc_2,fc_3,fc_2,fc_4,fc_5,fc_6];
fe = max(fe_s); % Suréchantillonnage


%% Génération  des signaux et suréchantillonnage au rythme fe

len = Tbuffer * fe;
time = randi([1, round(len*0.65)], 1, n); % Generer n instants de debuts differents
PTX = randi([50e5, 65e5],1,n);
B = fe;
temperatures = [150, -120];
idx = randi([1,2]);
To = temperatures(idx);

% coordonnées émetteur et récepteur
coord_sat = [randi([500 1000],1), randi([0 360],1), randi([0 90],1)];
altitude_Tx = randi([0 10],1,n);
longitude_Tx = randi([0 360],1,n);
latitude_Tx = randi([0 90],1,n);
coord_Tx = [altitude_Tx;longitude_Tx;latitude_Tx];

% Puissance des signaux
for i=1:n
PRx(i) = Puissance_generator(PTX(i), fc(i),B,coord_sat,coord_Tx(:,i),To);
end
PRx(:,1) = PRx(:,1) * 5;
PRx(:,5) = PRx(:,5) * 10;
PRx(:,6) = PRx(:,6) * 10;


[signal_1,~,~] = DSSS(N_1,B_1,fe_1,roll_off);                                      % DSSS
[signal_1] = upscale(signal_1,fe,fe_s(1),len, time(1),PRx(1));

signal_2 = onde_FM(m_FM,Am,Fm,k,p_FM,Ap,Fp_FM,OSR);
signal_2 = upscale(signal_2,fe,fe_s(2),len, time(2),PRx(2));

signal_3 = onde_AM(m_AM,Fm,k,p_AM,Ap,Fp_AM,OSR,'DBAP');                           % AM
signal_3 = upscale(signal_3,fe,fe_s(3),len, time(3),PRx(3));

signal_4 = onde_PM(m_AM,Fm,Am,p_AM,Ap,Fp_FM,OSR,5);                               % PM
% signal_4 = upscale(signal_4,fe,fe_s(4),len, time(4),PRx(4));

signal_5 = radar_pulse(100,10000,Fp_RadarPulse,OSR,5);
signal_5 = upscale(signal_5,fe,fe_s(5),len, time(5),PRx(5));

[signal_6,~] = CW(T_i,T_f, Te_3);                                                  % CW
signal_6 = upscale(signal_6,fe,fe_s(6),len, time(6),PRx(6));   

[signal_7,~] = FMCW(T_i,T_f,  Te_4, B_4, f_4);                                     % FMCW
signal_7 = upscale(signal_7,fe,fe_s(7),len, time(7),PRx(7)); 

%% Décalage  de chaque signal par rapport à l'instant de debut et stockage
% dans les colonnes d'une matrice

signaux = zeros(int32(len),n);
signaux(:,1) = signal_1;
signaux(:,2) = signal_2;
signaux(:,3) = signal_3;
% signaux(:,4) = signal_4;
signaux(:,5) = signal_5;
signaux(:,6) = signal_6;
signaux(:,7) = signal_7;
% signaux = signaux(1:int32(len),:);

    
%% signal recu
signal_recu = sum(signaux) ;

end



