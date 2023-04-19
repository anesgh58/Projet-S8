function [signal_recu,signaux,fe] = simulation(n,Tbuffer)
    
% Signaux numeriques
% DSSS
N_1 = 2^10;                                                   % Nombre de bits 
B_1 = 100e7;                                                  % Largeur de bande du signal
fe_1 = 50e8;                                                   % Fréquence d'échantillonage
roll_off = 0.5;                                               % Facteur de roll-off
fc_1 = 20*10^4;

% Signaux analogiques
% onde FM
Am=1;
Fm=1*10^3;
Ap=1;
k=0.5;
Fp=1*10^8;
OSR=4;
N_2=1000;
Fs=Fp*2^OSR;
Ts=1/Fs;
t=(0:Ts:(N_2-1)*Ts);
%Modulation
m=Am*cos(2*pi*Fm*t);
%Porteuse
p=Ap*cos(2*pi*Fp*t);
fe_2 = Fs;
fc_2 = Fp;

% Signaux radars
% CW
Te_3 = 4e-9;
fe_3 = 1/Te_3;
T_i = 20e-6;
T_f = 25e-6;
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
fe = max(fe_s); % Suréchantillonnage


%% Génération  des signaux et suréchantillonnage au rythme fe

[signal_1,~,~] = DSSS(N_1,B_1,fe_1,roll_off);                                    % DSSS
signal_1 = conv(signal_1,synchro(round(fe/fe_s(1))));
signal_2 = conv(onde_FM(m,Am,Fm,k,p,Ap,Fp,OSR),synchro(round(fe/fe_s(2))));      % FM
signal_3 = conv(onde_AM(m,Fm,k,p,Ap,Fp,OSR,'DBAP'),synchro(round(fe/fe_s(2))));  % AM
signal_4 = conv(onde_PM(m,Fm,Am,p,Ap,Fp,OSR,5),synchro(round(fe/fe_s(2))));      % PM
signal_5 = conv(radar_pulse(100,10000,Fp,OSR,5),synchro(round(fe/fe_s(2))));
[signal_6,~] = CW(T_i,T_f, Te_3);                                                % CW
signal_6 = conv(signal_6,synchro(round(fe/fe_s(3)))) ;                                
[signal_7,~] = FMCW(T_i,T_f,  Te_4, B_4, f_4);                                   % FMCW
signal_7= conv(signal_7,synchro(round(fe/fe_s(4))));

%% Décalage  de chaque signal par rapport à l'instant de debut et stockage
% dans les colonnes d'une matrice

len = Tbuffer * fe;
time = randi([1, round(len*0.65)], 1, n); % Generer n instants de debuts differents

signaux = zeros(int32(len),1);
signaux(time(1):length(signal_1)+time(1)-1,1) = signal_1;
signaux(time(2):length(signal_2)+time(2)-1,2) = signal_2;
signaux(time(3):length(signal_3)+time(3)-1,3) = signal_3;
signaux(time(4):length(signal_4)+time(4)-1,4) = signal_4;
signaux(time(5):length(signal_5)+time(5)-1,5) = signal_5;
signaux(time(6):length(signal_6)+time(6)-1,6) = signal_6;
signaux(time(7):length(signal_7)+time(7)-1,7) = signal_7;
signaux = signaux(1:int32(len),:);


%% Multiplication de chaque signal par PTX
PRx = zeros(1,n);
PTX = randi([40e5, 65e5],1,n);
B = 2 * fe;
coord_sat = [randi([500 1000],1), randi([0 360],1), randi([0 90],1)];
temperatures = [150, -120];
idx = randi([1,2]);
To = temperatures(idx);
coord_terre = zeros(3,n);
for i=1:n
%         coord a modifer
    coord_terre(:,i) = [randi([0 10],1), randi([0 360],1), randi([0 90],1)];
    PRx(i) = Puissance_generator(PTX(i), fc(i),B,coord_sat,coord_terre(:,i),To);
end
signaux = signaux .* PRx;
signaux(:,5) = 10 * signaux(:,5);
signaux(:,6) = 10 * signaux(:,6);
    
%% signal recu
signal_recu = zeros(int32(len),1);
for i=1:n
    signal_recu = signal_recu + signaux(:,i); 
end

end



