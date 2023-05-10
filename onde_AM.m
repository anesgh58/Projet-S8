function [s] = onde_AM(Fm,Am,k,Fp_AM,Ap,Tf,Ti,Te,type)

%m: Modulant
%k: Taux de modulation, utile que pour DBAP
%Ap: Amplitude porteuse
%Fp: Fréquence porteuse
%OSR: Ratio de dépassement
%Fmax: Fréquence maximum
%type: DBSP, DBAP et BLU
%Fm: Fréquence modulant


T = Tf - Ti;  % Durée du signal
t = Ti:Te:Tf; % Vecteur de temps

%Modulation
m=Am*cos(2*pi*Fm*t);
%Porteuse
p=Ap*cos(2*pi*Fp_AM*t);
if strcmp(type,"DBSP")
    s=p.*m;
end

if strcmp(type,'DBAP')
    s=p.*(1+k*m);
end

if strcmp(type,'BLU')
    s= m.*cos(2*pi*Fp*t) + m.*sin(2*pi*Fp*t);
end

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
% 
% %% Affichage

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