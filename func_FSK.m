function [sl, y]= func_FSK(fe, fs, T_i, T_f, fc0,fc1, filtre, SNR)
    
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

    % Génération des signaux modulés sur fc0 et fc1
    t = (0:Ns*Fse-1)*Te;
    s0 = sin(2*pi*fc0*t);
    s1 = sin(2*pi*fc1*t);

    % Modulation numérique FSK
    ss = zeros(1,length(t));
    for i=1:length(ss)
        if sl(i) == 0
            ss(i) = s0(i);
        else
            ss(i) = s1(i);
        end
    end

    %% Canal

    Ps = mean(abs(ss).^2); % Puissance instantannée de y
    Pn = Ps/10.^(SNR/10); % Puissance instantannée du bruit
    bruit = sqrt(Pn/2)*(randn(size(ss)) + 1i*randn(size(ss)));

    y = ss + bruit; % Trame bruitée

end
