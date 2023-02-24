function [s] = onde_FM(m,AP,Fp,AM,Fm,k,OSR)

%m: Modulant
%AP: Amplitude porteuse
%Fp: Fréquence porteuse
%AM: Amplitude modulant
%FM: Fréquence modulant
%k: Indice de modulation
%OSR: Ratio de dépassement

N=10000;
Fs=Fp*2^OSR;
Ts=1/Fs;
t= (1:N)*Ts;
Fi=Fp+k*m;
deltaf=Fi*AM;
beta=deltaf/Fm;
Tsm=1/Fm;

s=AP*cos(2*pi*Fp*t+beta.*sin(2*pi*Fm*t));

%% Affichage
% figure 
% plot(t,s);
% xlim([0 3*Tsm]);
% xlabel('Temps');
% title('Représentation Signal Modulé')
% grid on