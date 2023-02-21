%% Moniatte Thomas et Poulain Clément
clear;
close all;
clc;

%% Initialisation des paramètres
fe = 50e6;
M = 4;
n_b = log2(M);
Te = 1/fe;
Ds = 1e6; % fs = Ds
Ts = 1/Ds;
Ns = 10000;
Nb = Ns*n_b; % Nombre de bits
N_fft = 512;
Fse = Ts/Te; % Facteur de sur-échantillonage

f0 = 10e3;
sigA2 = 1; % Variance théorique des symboles
SNR=5;
% Pbruit = Prx / 10^(SNR/10);                                          % Puissance du bruit
eb_n0_dB = 0:0.5:10; % Liste des Eb/N0 en dB
eb_n0 = 10.^(eb_n0_dB/10); % Liste des Eb/N0

% g = ones(1,Fse);
Tg = 4*Ts;
g = rcosdesign(0.5,2*Tg/Ts,Fse,'sqrt');
ga = conj(flip(g));
Eg = sum(g.^2); % Energie du filtre de mise en forme
sigma2 = sigA2 * Eg ./ (n_b*eb_n0); % Variance du bruit complexe en bande de base

TEB = zeros(size(eb_n0)); % Tableau des TEB (résultats)
Pb = qfunc(sqrt(2*eb_n0)); % Tableau des probabilités d'erreurs théoriques

v0 = conv(ga,g);
v0_max = v0((1+length(v0))/2);


for i = 1:length(eb_n0)
    error_cnt = 0;
    bit_cnt = 0;
    while error_cnt < 100
        
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
    s_l = s_l.*exp(1i*2*pi*f0*temps*Te);
    s = real(s_l);
    
    %% Canal
    
%     n = sqrt(sigma2(i)/8)*(randn(size(s)) + 1j*randn(size(s))); % Génération du bruit blanc gaussien complexe
%     y = s + n;
    %y = s;
    SNR = 5;
    Prx = mean(abs(s).^2);                                              % Puissance inst du signal recue
    Pbruit = Prx / 10^(SNR/10);                                          % Puissance du bruit
    bruit = sqrt(Pbruit/2) * (randn(1,length(s)) + 1i*randn(size(s)));
    y = s + bruit;

    %% Architecture de reception par projections orthogonales
    
    x_oscil = 1:length(y);
    oscil_cos = 2*cos(2*pi*f0*x_oscil*Te);
    oscil_sin = -2*sin(2*pi*f0*x_oscil*Te); % Oscillateur pure déphasé de pi/2

    y_i = y.*oscil_cos;
    y_q = y.*oscil_sin;

    y_l_i = y_i;
    y_l_q = y_q;

    y_l = y_l_i + 1i.*y_l_q;
    %% Canal

    % Filtre adapté
	r_l = conv(y_l,ga);

    % Echantillonage au rythme Ts
    r_n = r_l(Fse:Fse:length(r_l)); %porte
    %r_n = r_l(1+2*Tg/Te:Fse:length(r_l)); %rcos
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
    
    
    for k=1:Nb
        if abs(s_b_end(k)-s_b(k)) == 1
            error_cnt = error_cnt + 1; % incrémenter le compte d'erreurs
        end
    bit_cnt = bit_cnt + 1; % incrémenter le compteur de bits envoyés
    end
    end
    TEB(i) = error_cnt/bit_cnt;
end

figure;
semilogy(eb_n0_dB,TEB);
hold on;
semilogy(eb_n0_dB,Pb);
grid on;
legend("Exp\'{e}rimentale","Th\'{e}orique",'Interpreter','latex');
title('QPSK : Evolution de TEB en fonction de $ \frac{E_b}{N_0} $','Interpreter','latex');
xlabel('$ \frac{E_b}{N_0} $ (en dB)','Interpreter','latex');
ylabel("Taux d'Erreur Binaire",'Interpreter','latex');
% txt = 'Filtre : Porte'; % g : porte
txt = "Filtre : Racine de cosinus sur-\'{e}lev\'{e}"; % g : racine de cosinus sur-élevé
a = annotation('textbox',[0.131 0 0 0.173],'String',txt,'FitBoxToText','on','Interpreter','latex');
a.BackgroundColor = 'w';

figure;
[dsp_s_l,f] = pwelch(s_l,rectwin(N_fft),0,N_fft,fe,'centered');
%Dsp théorique de la porte 
% dsp_s_l_th = Ts*sinc(Ts*(f-f0)).^2;
% Dsp théorique de rcos 
dsp_s_l_th = 1/2*(1+cos(pi*Ts/0.5*(abs(f-f0)-(0.5/2/Ts))));
for i=1:length(f)
    if abs(f(i)-f0)<0.5/2/Ts
        dsp_s_l_th(i)=1;
    end
    if abs(f(i)-f0)>1.5/2/Ts
        dsp_s_l_th(i)=0;
    end
end
dsp_s_l_th=dsp_s_l_th*max(dsp_s_l);

semilogy(f,dsp_s_l);
title("DSP th\'{e}orique \& DSP exp\'{e}rimentale",'Interpreter','latex');
hold on;
semilogy(f,dsp_s_l_th);
xlabel("Fr\'equence ( en Hz)",'Interpreter','latex');
ylabel('Amplitude u.a','Interpreter','latex');
legend("Exp\'{e}rimentale", "Th\'{e}orique",'Interpreter','latex');
grid on;
