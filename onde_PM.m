function [s] = onde_PM(Fm,Am,Ap,Fp,Tf,Ti,Te,kf)

%m: Modulant
%Ap: Amplitude porteuse
%Fp: Fréquence porteuse
%Am: Amplitude modulant
%Fm: Fréquence modulant
%k: Indice de modulation
%OSR: Ratio de dépassement
%kf

T = Tf - Ti;  % Durée du signal
t = Ti:Te:Tf; % Vecteur de temps
% t = t(1:length(t)-1);
%Modulation
m=Am*cos(2*pi*Fm*t);
%Porteuse
p=Ap*cos(2*pi*Fp*t);
beta=(kf*Am)/Fm;

% Calcul de la modulation de phase PM
s = Ap.*cos(2*pi*Fp*t + beta*sin(2*pi*Fm*t));

% %% Calcul du périodogramme
% 
% [Perio,f] = periodogram(s,'centered');
% 
% figure,
% plot(f,Perio);
% xlabel('Fréquence (Hz)');
% ylabel('Densité spectrale de puissance');
% grid on;
% title('Periodogramme du signal');
% 
% %% Calcul de la transformée de Fourrier
% 
% TF=fft(s);
% 
% figure,
% plot(real(TF));
% grid on;
% title("Transformée de Fourier du signal");
% 
% %% Affichage
% 
% figure,
% subplot(3,1,1);
% plot(t,p);
% xlabel('Temps');
% xlim([Ti Ti+Te*200]);
% title('Représentation de la porteuse');
% grid on;
% 
% subplot(3,1,2);
% plot(t,m);
% xlabel('Temps');
% xlim([Ti Ti+T]);
% title('Représentation du modulant');
% grid on;
% 
% subplot(3,1,3);
% plot(t,s);
% xlim([Ti Ti+Te*200]);
% xlabel('Temps');
% title('Représentation du signal modulé en amplitude')
% grid on;
