function [s,ss,ss_spread] = DSSS(N,B,fe,roll_off,f)

%% Parametres
nb = 1;                                                       % Nombre de bit/symbole (BPSK)
Ts = 1/(2*B);                                                   % Temps symbole
Te = 1/fe;                                                    % Période d'échantillonage
Fse = Ts/Te;                                                  % Facteur de sur-échantillonage
Span = 8;
g = rcosdesign(roll_off,Span,floor(Fse),'sqrt'); % filtre de mise en forme
%% Tx 
% Flux binaire généré aléatoirement
sb = randn(1,N * nb) > 0;  % Flux binaire uniformement distribue, sinon constellation dsiquilibre --> DSP contiendra des raies, Pe non minimisee

% Modulation BPSK
ss = 2*sb-1;               % Flux de symboles BPSK

% Séquence pseudo-aléatoire
pnseq = comm.PNSequence('Polynomial', 'z^3 + z^2 + 1','SamplesPerFrame', 7, 'InitialConditions', [0 0 1]);     
c = pnseq().';
for i=1:length(c)
    if c(i)==0
        c(i)=-1;
    end
end

% Etalement de la séquence binaire
spread = length(ss)*length(c);
ss_spread = zeros(1,spread);
j=1;
for i=1:length(ss)
    ss_spread(j:j + length(c)-1) = repmat(ss(i),[1,length(c)]).* c;
    j = j + length(c);
end

% filtre de mise en forme
sl = conv(ss_spread,g,'same');
   
% Emission du signal en bande de base
t = 0:Te:(length(sl)-1)*Te;  
s = sl .* cos(2*pi*f*t);
% s = sl;

end

