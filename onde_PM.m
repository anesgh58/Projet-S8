function [s] = onde_PM(m,AP,Fp,AM,Fm,k,OSR,Fmax)
% 
% %m: Modulant
% %AP: Amplitude porteuse
% %Fp: Fréquence porteuse
% %AM: Amplitude modulant
% %FM: Fréquence modulant
% %k: Indice de modulation
% %OSR: Ratio de dépassement
% 



% % Définition des paramètres de modulation PM
% fc = 100; % fréquence de la porteuse
% fm = 10; % fréquence du signal modulant
kf = 10; % sensibilité de la fréquence de modulation
% A = 1; % amplitude de la porteuse
indm = 0.5; % indice de modulation
% 
% % Création des signaux porteur et modulant
% t = linspace(0, 1, 1000); % vecteur temps
% carrier = A * cos(2*pi*fc*t); % signal porteur
% modulating = m * sin(2*pi*fm*t); % signal modulant

N=10000;
Fs=Fmax*2^OSR;
Ts=1/Fs;
t= (0:N-1)*Ts;
p=AP*cos(2*pi*Fp*t);    %Porteuse
Tsm=1/Fm;

% Calcul de la modulation de phase PM
s = p.*cos(2*pi*(Fp + kf*indm)*t);

%s=AP*cos(2*pi*Fp*t+deltaPhi)

figure 
plot(t,s);
xlim([0 3*Tsm]);
xlabel('Temps');
title('Représentation Signal Modulé en phase')
grid on

