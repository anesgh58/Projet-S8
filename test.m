[test_signal, window_length, noverlap,fe,longi, lati, teta, gama,t,f,spect_binarise] = simul();
%%
figure, 
colors = colormap(lines(12));
polarplot(0, 0 ,'kx','LineWidth',1.5);

for i = 1:length(teta)
    color_index = mod(i-1, 12)+1; % Choix de la couleur en fonction de l'indice de la boucle
    polarplot(gama(i), 1,'Marker','o','MarkerEdgeColor',colors(color_index,:),'LineWidth',1.5);
    polarplot(teta(i), 1 ,'Marker','x','MarkerEdgeColor',colors(color_index,:),'LineWidth',1.5);

    hold on,
end
   

title("AOA ")

%%
figure,
colors = colormap(lines(12));
    geoplot(0,0) % carte du monde
    geolimits([43 47.5],[-2 6]) % limites de la carte
    % Ajout des points sur la carte
    hold on, 
    for a = 1:ns
            color_index = mod(a-1, 12)+1; % Choix de la couleur en fonction de l'indice de la boucle

        geoscatter(lati(a),longi(a), 'x','MarkerEdgeColor',colors(color_index,:),'LineWidth',1.5) ;
        geoscatter(coord_Tx(a,1),coord_Tx(a,2), '+','MarkerEdgeColor',colors(color_index,:),'LineWidth',2.5);
    end
    geobasemap streets-light  % fond de carte
% Figures

% Spectrogramme du signal reçu
figure,
spectrogram(test_signal, window_length, noverlap, [], fe, 'yaxis');
title('Spectrogramme du signal reçu')

% Binarisation
figure,
imagesc(t,f,spect_binarise)
colormap("gray");
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;
title('Spectrogramme du signal binarisé')
