function [s] = onde_FM(m,Am,Fm,k,p,Ap,Fp,OSR)

%m: Modulant
%Ap: Amplitude porteuse
%Fp: Fréquence porteuse
%Am: Amplitude modulant
%FM: Fréquence modulant
%k: Indice de modulation
%OSR: Ratio de dépassement

N=10000;
Fs=Fp*2^OSR;
Ts=1/Fs;
t= (0:N-1)*Ts;
Fi=Fp+k*m;
deltaf=Fi*Am;
beta=deltaf/Fm;
Tsm=1/Fm;

s=Ap*cos(2*pi*Fp*t+beta.*sin(2*pi*Fm*t));

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

figure,
subplot(3,1,1);
plot(t,p);
xlabel('Temps');
xlim([0 3*Tsm]);
title('Représentation de la porteuse');
grid on;

subplot(3,1,2);
plot(t,m);
xlabel('Temps');
xlim([0 3*Tsm]);
title('Représentation du modulant');
grid on;

subplot(3,1,3);
plot(t,s);
xlim([0 3*Tsm]);
xlabel('Temps');
title('Représentation du signal modulé en fréquence')
grid on;