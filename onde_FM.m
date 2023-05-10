function [s] = onde_FM(Am,Fm,k,Ap,Fp,Ti,Tf,Te)

%m: Modulant
%Ap: Amplitude porteuse
%Fp: Fréquence porteuse
%Am: Amplitude modulant
%FM: Fréquence modulant
%k: Indice de modulation
%OSR: Ratio de dépassement

T = Tf - Ti;  % Durée du signal
t = Ti:Te:Tf; % Vecteur de temps
%Modulation
m=Am*cos(2*pi*Fm*t);
%Porteuse
p=Ap*cos(2*pi*Fp*t);

Fi=Fp+k*m;
deltaf=Fi*Am;
beta=deltaf/Fm;


s=Ap*cos(2*pi*Fp*t+beta.*sin(2*pi*Fm*t));

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

% figure,
% subplot(3,1,1);
% plot(t,p);
% xlabel('Temps');
% xlim([Ti Ti+Te*1000]);
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
% xlim([Ti Ti+Te*1000]);
% xlabel('Temps');
% title('Représentation du signal modulé en fréquence')
% grid on;