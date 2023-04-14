function [sl, y]= func_ASK(fe, fs, T_i, T_f, fc, filtre, SNR)

    %% Initialisation des paramètres
    Te = 1/fe;
    Ts = 1/fs;
    Fse = Ts/Te; % Facteur de sur-échantillonage
    Ns = round((T_f-T_i)*fe);

    if filtre == "porte"
        g = ones(1,Fse);
    elseif filtre == "cosinus surélevé"
        Tg = 4*Ts;
        g = rcosdesign(0.5,2*Tg/Ts,Fse,'sqrt');
    end
    
    %% Emetteur

    sb = randi([0,1],1,Ns);

    % Sur-echantillonage sur fe

    sl = upsample(sb,Fse);

    % Filtre de mise en forme

    sl = filter(g,1,sl);
  
    % Multiplication par la fréquence porteuse 

    temps = 1:length(sl);
    s = real(sl.*exp(1i*2*pi*fc*temps*Te));

    %% Canal

    Ps = mean(abs(s).^2); % Puissance instantannée de y
    Pn = Ps/10.^(SNR/10); % Puissance instantannée du bruit
    bruit = sqrt(Pn/2)*(randn(size(s)) + 1i*randn(size(s)));

    y = s + bruit; % Trame bruitée

end