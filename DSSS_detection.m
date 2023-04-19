function [pho,Lc_est] = DSSS_detection(signal_recu)


%% DSSS detection

segments = buffer(signal_recu,128,0);   % Decouper sl en 100 vecteurs colonnes
sze = size(segments);                   % taille de la matrice

% Autocorrelation de chaque segment
for i = 1:sze(2)
 cor(:,i) = xcorr(abs(segments(:,i)).^2);
end

% Moyenne ponderee des fenêtres
sze_cor = size(cor);
pho = zeros(sze_cor(1),1); % in
for i = 1:sze_cor(2)
 pho = pho + cor(:,i);
end
pho = pho/sze_cor(1);

% Estimation de Lc à partir de la période du signal
maximum = max(pho);
[~,locs]=findpeaks(pho,'MinPeakHeight',maximum/1.5);
Lc_est = round((locs(end) - locs(1))/(length(locs)-1));

end

