function [s] = radar_pulse(tau,dur,Fp,OSR,nbrepet)

%tau la durée de la pulsion 
%dur la durée totale du signal 
%nbrepet le nombre de fois qu'on répète le signal

Fs=Fp*2^OSR;
Ts=1/Fs;
t= (0:dur-1)*Ts;
vartp=[ones(1,tau),zeros(1,dur-tau)];
var=repmat(vartp,1,nbrepet);
t=repmat(t,1,nbrepet);
s=var.*sin(2*pi*Fp*t);

%% Calcul du périodogramme

[Perio,f] = periodogram(s,'centered');

figure,
plot(f,Perio);
xlabel('Fréquence (Hz)');
ylabel('Densité spectrale de puissance');
grid on;
title('Periodogramme du signal');

%% Calcul de la transformée de Fourrier

TF=fft(s);

figure,
plot(real(TF));
grid on;
title("Transformée de Fourier du signal");

%% Affichage

figure 
plot(s);
xlim([0 3*dur]);
xlabel('Temps');
title('Représentation Signal radar pulsé')
grid on