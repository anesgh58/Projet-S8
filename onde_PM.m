function [s] = onde_PM(m,AP,Fp,AM,Fm,k,OSR)

%m: Modulant
%AP: Amplitude porteuse
%Fp: Fréquence porteuse
%AM: Amplitude modulant
%FM: Fréquence modulant
%k: Indice de modulation
%OSR: Ratio de dépassement

s=AP*cos(2*pi*Fp*t+deltaPhi)