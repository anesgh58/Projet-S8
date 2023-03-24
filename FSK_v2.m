clear;
close all;
clc

%% Initialisation des paramètres


fe = 100e3;
Te = 1/fe;
Ds = 1000; % fs = Ds
Ts = 1/Ds;
Ns = 5000;
Fse = Ts/Te; % Facteur de sur-échantillonage
delta_f = 50;

f0 = 1000; % Fréquence porteuse 0
f1 = 3000; % Fréquence porteuse 1

g = ones(1,Fse);
Tg = 4*Ts;
%g = rcosdesign(0.5,2Tg/Ts,Fse,'sqrt');
ga = conj(flip(g));
Eg = sum(g.^2); % Energie du filtre de mise en forme

v0 = conv(ga,g);
v0_max = v0((1+length(v0))/2);

h = 1;
SNR = 50;

%% Emetteur

sb = randi([0,1],1,Ns);

% Génération des signaux modulés sur f0 et f1
t = (0:Ns*Fse-1)*Te;
s0 = sin(2*pi*f0*t);
s1 = sin(2*pi*f1*t);

% Modulation numérique FSK
ss = zeros(1,length(t));
for i=1:Ns
    if sb(i) == 0
        ss((i-1)*Fse+1:i*Fse) = s0((i-1)*Fse+1:i*Fse);
    else
        ss((i-1)*Fse+1:i*Fse) = s1((i-1)*Fse+1:i*Fse);
    end
end

%% Canal

s = filter(h,1,ss);

Ps = mean(abs(s).^2); % Puissance instantannée de y
Pn = Ps/10.^(SNR/10); % Puissance instantannée du bruit
bruit = sqrt(Pn/2)*(randn(size(s)) + 1i*randn(size(s)));

y = s + bruit; % Trame bruitée

%% Récepteur

% Décodage du signal reçu
sb_estime = zeros(1,Ns);

for i=1:Ns
    t = (i-1)*Fse+1:i*Fse;
    ss0 = y(t).*sin(2*pi*f0*(t-((i-1)*Fse+(Fse-1)/2))*Te);
    ss1 = y(t).*sin(2*pi*f1*(t-((i-1)*Fse+(Fse-1)/2))*Te);
    energy0 = sum(abs(ss0).^2);
    energy1 = sum(abs(ss1).^2);
    sb_estime(i) = (energy1>energy0);
end

% Calcul du taux d'erreur binaire (BER)
BER = mean(abs(sb_estime-sb));

N = 15;

figure(1);
subplot(2,1,1);
plot((0:N-1)/fe, sb(1:(N)),'LineWidth', 2,'Color','black');
xlabel('Temps (en s)');
ylabel('Amplitude');
ylim([-0.1 1.1]);
title("S\'{e}quence binaire");
grid on;

subplot(2,1,2);
plot((0:N*Fse-1)/fe, real(s(1:N*Fse)),'LineWidth', 2,'Color','black');
xlabel('Temps (en s)');
ylabel('Amplitude');
ylim([-1.1 1.1]);
title("Partie r\'{e}elle de l'enveloppe complexe");
grid on;

figure(2);
Nfft = 512;
[dsp_sl,f] = pwelch(y,rectwin(Nfft),0,Nfft,fe,'centered');

semilogy(f,dsp_sl);
title("P\'{e}riodogramme du signal re\c cu");
xlabel("Fr\'equence (en Hz)");
ylabel('Amplitude');
grid on;