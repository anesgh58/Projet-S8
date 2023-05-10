function [s] = radar_pulse(tau,durect,Tf,Ti,Te,Fp)

%tau: durée de la pulsion 
%durect: durée de l'écoute
%dur: durée totale du signal 
%nbrepet: nombre de fois qu'on répète le signal

T = Tf - Ti;  % Durée du signal
t = Ti:Te:Tf; % Vecteur de temps
%tvar = tau+durect;
lenTau=floor(tau*length(t)/T);
lenEct=floor(durect*length(t)/T);
vartp = [ones(1,lenTau),zeros(1,lenEct)];
nbrep = floor(length(t)/length(vartp))+1;
var = repmat(vartp,1,nbrep);
var = var(1:length(t));
s = var.*sin(2*pi*Fp*t);

% %% Calcul du périodogramme
% 
% [Perio,f] = periodogram(s,'centered'); 
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
% figure 
% plot(s);
% xlabel('Temps');
% title('Représentation Signal radar pulsé')
% grid on