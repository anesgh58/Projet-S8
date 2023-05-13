function y_m = FHSS(Ti, Tf, fc, fe, B)

    Te = 1/fe; % période d'échantillonnage
    tau = Tf - Ti ; 
    Ts = 1/B ;
    n_s = round(tau/Ts) ;
    n_b_s = 1 ;
    n_b = n_s*n_b_s ;
    % Paramètres du filtre de mise en forme
    
    Fse = round(Ts/Te) ;  % nombre d'échantillons par symbole
    span = 6; % longueur de la réponse impulsionnelle du filtre en symboles
    rolloff = 0.9; % facteur de roll-off du filtre
    h = rcosdesign(rolloff, span, Fse); % réponse impulsionnelle du filtre
    
    % Données à moduler
    data = randi([0 1], 1, n_b); % 2^10 bits aléatoires
    
    % Conversion des données binaires en symboles 2_PSK
    symbols = 2*data - 1; 
    symbols = upsample(symbols,Fse) ;
    % Modulation FHSS pour chaque sous trame
    phases = cumsum(2*pi*Te*symbols); % calcul des phases instantanées
    x = exp(1i*phases); % signal modulé 
    t = (0:length(x)-1)*Te; % vecteur temps
    % matrice des sous trames
    M = 2^6 ;
    N = floor(length(x)/M) ;
    mat_s = reshape(x(1:N*M),M,[]);
    mat_t = reshape(t(1:N*M),M,[]);
    
    [~, n] = size(mat_s) ;
    for i = 1:n
        % Ajout de la fréquence de la porteuse
        alpha = randi([-1,1]) ;
        f_t = alpha*1e6 ; % fréquence à ajouté
        carrier = exp(1i*2*pi*(fc + f_t)*mat_t(:,i)); % signal de la porteuse
        mat_s(:,i) = mat_s(:,i) .* carrier; % signal modulé final
    end
    y_m = real(mat_s(:))' ;
    
    % Filtrage de mise en forme
     
    %y_m = filter(h, 1, y); % signal modulé passe-bas
end
