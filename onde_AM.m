function [s] = onde_AM(m,k,AP,Fp,OSR,Fmax,type,FM)

%m: Modulant
%k: Taux de modulation, utile que pour DBAP
%AP: Amplitude porteuse
%Fp: Fréquence porteuse
%OSR: Ratio de dépassement
%Fmax: Fréquence maximum
%type: DBSP, DBAP et BLU
%FM: Fréquence modulant

N=10000;
Fs=Fmax*2^OSR;
Ts=1/Fs;
t= (1:N)*Ts;
p=AP*cos(2*pi*Fp*t);    %Porteuse
Tsm=1/FM;
if strcmp(type,"DBSP")
    s=p.*m;
end

if strcmp(type,'DBAP')
    s=p.*(1+k*m);
end

if strcmp(type,'BLU')
    s= m.*cos(2*pi*Fp*t) + m.*sin(2*pi*Fp*t);
end

figure 
plot(t,s);
xlim([0 3*Tsm]);
xlabel('Temps');
title('Représentation Signal Modulé')
grid on