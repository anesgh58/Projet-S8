clear,
close all,
clc,

Am=1;
Fm=1*10^3;
Ap=1;
k=0.5;
Fp=10*10^3;

OSR=4;
N=10000;
Fmax=10*10^3;
Fs=Fmax*2^OSR;
Ts=1/Fs;
t= (1:N)*Ts;
%Modulation
m=Am*cos(2*pi*Fm*t);

%Porteuse
p=Ap*cos(2*pi*Fp*t);

onde_AM(m,Fm,k,p,Ap,Fp,OSR,'DBAP');

onde_FM(m,Am,Fm,k,p,Ap,Fp,OSR);

onde_PM(m,Fm,Am,p,Ap,Fp,OSR,5);

radar_pulse(100,10000,Fp,OSR,5);