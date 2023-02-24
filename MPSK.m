clear;
close all;
clc;

%% Initialisation des paramètres


fe = 10e3;
M = 8;
n_b = log2(M);
Te = 1/fe;
Ds = 1000; % fs = Ds
Ts = 1/Ds;
Ns = 5000;
Nb = Ns*n_b; % Nombre de bits
Fse = Ts/Te; % Facteur de sur-échantillonage

fc = 2.5e3;

g = ones(1,Fse);
Tg = 4*Ts;
%g = rcosdesign(0.5,2*Tg/Ts,Fse,'sqrt');
ga = conj(flip(g));
Eg = sum(g.^2); % Energie du filtre de mise en forme


v0 = conv(ga,g);
v0_max = v0((1+length(v0))/2);

h = 1;
SNR = 5;
      
%% Emetteur

sb = randi([0,M-1],1,Ns);
sb_bin = de2bi(sb,n_b,'left-msb')';
sb_bin = sb_bin(:)';

% Modulateur numérique 

ss = pskmod(sb,M,0, InputType='integer');

% Sur-echantillonage sur fe

sl = upsample(ss,Fse);

% Filtre de mise en forme

sl = filter(g,1,sl);
  
% Multiplication par la fréquence porteuse 

temps = 1:length(sl);
s = real(sl.*exp(1i*2*pi*fc*temps*Te));

%% Canal

s = filter(h,1,s);

Ps = mean(abs(s).^2); % Puissance instantannée de y
Pn = Ps/10.^(SNR/10); % Puissance instantannée du bruit
bruit = sqrt(Pn/2)*(randn(size(s)) + 1i*randn(size(s)));

y = s + bruit; % Trame bruitée

% Etage RF -> BDB

oscil_I = 2*cos(2*pi*fc*temps*Te);
oscil_Q = -2*sin(2*pi*fc*temps*Te); % Oscillateur pure déphasé de pi/2
yI = y.*oscil_I;
yQ = y.*oscil_Q; 
yl = yI + 1i*yQ;

%% Récepteur

% Filtre adapté
rl = filter(ga,1,yl);

% Echantillonage au rythme Ts
rn = rl(Fse:Fse:end); %porte
%rn = rl(1+2*Tg/Te:Fse:end); %rcos
rn = rn/v0_max;
    
sb_estime = pskdemod(rn,M,0,'gray',OutputType='integer');
sb_estime_bin = de2bi(sb_estime,n_b,'left-msb')';
sb_estime_bin = sb_estime_bin(:)';

% TEB
BER = mean(abs(sb_estime_bin-sb_bin(1:length(sb_estime_bin))));
    

%% Figures
set(0,'defaulttextInterpreter','latex')

N = 50;
figure(1);
plot((0:N-1)/fe, real(s(1:N)));
xlabel('Temps (en s)');
ylabel('Amplitude');
xlim([-N/(20*fe) N/fe+N/(20*fe)])
ylim([-1.1 1.1]);
grid on;
title("Partie r\'{e}elle de l'enveloppe complexe");

figure(2);
plot(real(rn), imag(rn), 'o');
title("Constellation des symboles d\'{e}tect\'{e}s");
xlabel('I');
ylabel('Q');
grid on;

figure(3);
Nfft = 512;
[dsp_sl,f] = pwelch(y,rectwin(Nfft),0,Nfft,fe,'centered');

semilogy(f,dsp_sl);
title("P\'{e}riodogramme du signal re\c cu");
xlabel("Fr\'equence (en Hz)");
ylabel('Amplitude');
grid on;

