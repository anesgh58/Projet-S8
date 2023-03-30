function y_m = FHSS(fc, fe, B)

    Te = 1/fe; % période d'échantillonnage
    n_b = 2^10 ; % nb de bits
    
    % Paramètres du filtre de mise en forme
    Ts = 1/B ;
    Fse = round(Ts/Te); % nombre d'échantillons par symbole
    span = 10; % longueur de la réponse impulsionnelle du filtre en symboles
    rolloff = 0.2; % facteur de roll-off du filtre
    h = rcosdesign(rolloff, span, Fse); % réponse impulsionnelle du filtre
    
    % Données à moduler
    data = randi([0 1], 1, n_b); % 1000 bits aléatoires
    
    % Conversion des données binaires en symboles 2_PSK
    symbols = 2*data - 1; 
    
    % Modulation FHSS pour chaque sous trame
    phases = cumsum(2*pi*Fse*symbols); % calcul des phases instantanées
    x = exp(1i*phases); % signal modulé 
    t = (0:length(x)-1)*Te; % vecteur temps
    % matrice des sous trames
    M = 2^6 ;
    mat_s = reshape(x,M,[]);
    mat_t = reshape(t,M,[]);
    
    [~, n] = size(mat_s) ;
    for i = 1:n
        % Ajout de la fréquence de la porteuse
        alpha = randi(10)
        f_t = alpha*1000000 ; % fréquence à ajouté
        carrier = exp(1i*2*pi*(fc + f_t)*mat_t(:,i)); % signal de la porteuse
        mat_s(:,i) = mat_s(:,i) .* carrier; % signal modulé final
    end
    y = real(mat_s(:)) ;
    
    % Filtrage de mise en forme
    y = upsample(y,Fse);
    y_m = filter(h, 1, y); % signal modulé passe-bas
end
