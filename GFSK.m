function y_m = GFSK(Ti, Tf, fe, fc, N, B)

    % Paramètres du filtre de mise en forme
    tau = Tf - Ti ; 
    Te = 1/fe; % période d'échantillonnage
    Ts = 1/B ; % durée de symbole
    n_s = round(tau/Ts) ;
    n_b_s = 1 ;
    Fse = round(Ts/Te);  % nombre d'échantillons par symbole
    f_delta = 0.5 ;
    span = 10; % longueur de la réponse impulsionnelle du filtre en symboles
    rolloff = 0.2; % facteur de roll-off du filtre
    h = rcosdesign(rolloff, span, Fse, 'sqrt'); % réponse impulsionnelle du filtre
    
    % Données à moduler
    data = randi([0 1], 1, n_s*n_b_s); % 1000 bits aléatoires
    
    % Conversion des données binaires en symboles 2_PSK
    symbols = 2*data - 1;
    %symbols = data ;
    % filtrage gaussien
    w = 5*gausswin(N);
    
    % convolution avec le filtre gaussien
    symbols = upsample(symbols,Fse);
    S_g = filter(w, 1, symbols); 

    % Modulation GFSK
    phases = cumsum([0, 2*pi*f_delta*Te*S_g]); % calcul des phases instantanées
    x = exp(1i*phases); % signal modulé en GFSK
    
    % Ajout de la fréquence de la porteuse
    t = (0:length(x)-1)*Te; % vecteur temps
    carrier = exp(1i*2*pi*fc*t); % signal de la porteuse
    y_m = real(x .* carrier); % signal modulé final
    
    % Filtrage de mise en forme
    %y_m = filter(h, 1, y); % signal modulé passe-bas

end