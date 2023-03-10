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


figure 
plot(s);
xlim([0 3*dur]);
xlabel('Temps');
title('Représentation Signal radar pulsé')
grid on