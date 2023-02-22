clear;
close all;
clc;

%% Initialisation des paramètres
fe = 50e6;  % Fréquence d'échantillonage
M = 4;
n_b = log2(M);
Te = 1/fe;
Ds = 1e6; % Débit symbole ( = fréquence symbole)
Ts = 1/Ds;
Ns = 1000;
Nb = Ns*n_b; % Nombre de bits
Fse = Ts/Te; % Facteur de sur-échantillonage

fc = 10e6; % Fréquence porteuse

Tg = 4*Ts;
g = rcosdesign(0.5,2*Tg/Ts,Fse,'sqrt');
ga = conj(flip(g));

v0 = conv(ga,g);
v0_max = v0((1+length(v0))/2);

       
%% Emetteur
s_b = randi([0,1],1,Nb);
s_s = zeros(1,Ns);
    
    symboles = exp(1i*2*pi*(0:M-1)/M);

    for ii=1:n_b:Nb
        if s_b(ii) == 0 && s_b(ii+1) == 0
            s_s(ceil(ii/n_b)) = symboles(1);
        elseif s_b(ii) == 0 && s_b(ii+1) == 1
            s_s(ceil(ii/n_b)) = symboles(2);
        elseif s_b(ii) == 1 && s_b(ii+1) == 1
            s_s(ceil(ii/n_b)) = symboles(3);
        else 
            s_s(ceil(ii/n_b))= symboles(4);
        end
    end

    % Sur-echantillonage sur fe 
    s_l = upsample(s_s,Fse);
    s_l = conv(s_l,g);
    
    %% Multiplication par la fréquence porteuse 

    temps = 1:length(s_l);
    s_l = s_l.*exp(1i*2*pi*fc*temps*Te);
    s = real(s_l);
    
    %% Canal
    
    SNR = 5;
    Prx = mean(s.^2);  % Puissance instantanée du signal reçu
    Pbruit = Prx / 10^(SNR/10); % Puissance du bruit
    bruit = sqrt(Pbruit/2) * (randn(1,length(s)) + 1i*randn(size(s)));
    y = s + bruit;

    %% Descente en fréquence : architecture de reception par projections orthogonales
    
    x_oscil = 1:length(y);
    oscil_cos = 2*cos(2*pi*fc*x_oscil*Te);
    oscil_sin = -2*sin(2*pi*fc*x_oscil*Te); % Oscillateur pure déphasé de pi/2

    y_l_i = y.*oscil_cos;
    y_l_q = y.*oscil_sin;

    y_l = y_l_i + 1i.*y_l_q;

    %% Canal

    % Filtre adapté
	r_l = conv(y_l,ga);

    % Echantillonage au rythme Ts
    r_n = r_l(1+2*Tg/Te:Fse:length(r_l)); %rcos
    r_n = r_n/v0_max;
    
    %% Recepteur

    s_s_end = zeros(1,Ns);

    % Méthode du plus proche voisin
    for k=1:Ns
        min_val = min([abs(r_n(k)-symboles)]);
        for ii=1:M
            if abs(r_n(k)-symboles(ii)) == min_val
                s_s_end(k) = symboles(ii);
            end
        end
    end

    s_b_end = zeros(1,Nb);
    for k=1:Ns
        if s_s_end(k) == symboles(1)
            s_b_end(n_b*k-1) = 0;
            s_b_end(n_b*k) = 0;
        elseif s_s_end(k) == symboles(2)
            s_b_end(n_b*k-1) = 0;
            s_b_end(n_b*k) = 1;
        elseif s_s_end(k) == symboles(3)
            s_b_end(n_b*k-1) = 1;
            s_b_end(n_b*k) = 1;
        else
            s_b_end(n_b*k-1) = 1;
            s_b_end(n_b*k) = 0;
        end
    end

res = isequal(s_b_end, s_b);
diff = sum(abs(s_b_end-s_b));

%% Périodogramme du signal reçu bruité avec descente en fréquence

figure;
N_fft = 512;
[dsp_s_l,f] = pwelch(s_l,rectwin(N_fft),0,N_fft,fe,'centered');

semilogy(f,dsp_s_l);
title("P\'{e}riodogramme du signal re\c cu",'Interpreter','latex');
xlabel("Fr\'equence ( en Hz)",'Interpreter','latex');
ylabel('Amplitude u.a','Interpreter','latex');
grid on;
