function [test_signal, window_length, noverlap,fe,longi, lati, teta, gama,t,f,spect_binarise] = simul()
%% Paramètres
n=7;                                      % Nombre de signaux à générer
Tbuffer = 500e-6;                         % Durée du signal d'enregistrement (en secondes)
seuil = 70;                               % Seuil énergétique
ns = 1;
d = 0;
lati = 0;
while sum(lati~=0)<4
while (d ~= ns) 
    %% Génération  du stimuli
    [signal_recu,signaux,fe,~, coord_Tx] = simulation(n,Tbuffer); % Génération du stimuli
    [~, ns] = size(signaux);
    %% spectrogramme
    window_length = round((fe*Tbuffer)/100);                                             % Longueur de la fenêtre
    noverlap = round(window_length/2);                                                   % Chevauchement des fenêtres
    test_signal = signal_recu ;
    [~,f,t,pxx] = spectrogram(test_signal, window_length, noverlap, [], fe, 'yaxis');


    %% Binarisation
    spect_binarise = pow2db(pxx)>seuil;
    %% Identification des temps d'émission,temps de réception et fréquences porteuses
    donnees = identification(spect_binarise,t,f); % Matrice contenant dans sa colonne la fréquence porteuse fp, temps d'émission Tx et temps de réception Tr. 
    [~, d] = size(donnees);
end
%% filtrage (filtre PB et PH + décimation)
%[signaux_classifications,signal_low_all,signal_high_all] = filtrage(N,test_signal,B,h_low,h_high,bandwith_signal,i,signal_low_all,signal_high_all);

%% classification

%% Localisation
A = [1:length(donnees); donnees]';
Rx1 = [46,2,550000];
Rx2 = [46.0000045, 2, 550000];
Rx3 = [46, 2.000006, 550000];
Rx = [Rx1;Rx2;Rx3];
coord_Tx = coord_Tx';
%% Estimation du temps de réception
vitesse_propagation = 3e8; % mètres par seconde
temps_reception = zeros(length(coord_Tx), 3);
for j = 1:3
    for i = 1:length(coord_Tx)
        dist = distance_geodesique(coord_Tx(i,:), Rx(j,:));
        % Temps d'émission
        temps_emission = A(i,3);
        % Temps de réception
        temps_reception(i,j) = temps_emission + (dist / vitesse_propagation);
    end
end
A1 = A;
A1(:,3) = temps_reception(:,1);
A2 = A;
A2(:,3) = temps_reception(:,2);
A3 = A;
A3(:,3) = temps_reception(:,3);

%% AOA
d = [distance_geodesique(Rx1,Rx2) distance_geodesique(Rx1,Rx3)];
c = 3e8;
[longi, lati, teta, gama] = AOA_function(A1,A2,A3, d, c, coord_Tx);

end
% %%
% figure, 
% colors = colormap(lines(12));
% %polarplot(0, 0 ,'kx','LineWidth',1.5);
% 
% for i = 1:length(teta)
%     color_index = mod(i-1, 12)+1; % Choix de la couleur en fonction de l'indice de la boucle
%     polarplot(gama(i), 1,'Marker','o','MarkerEdgeColor',colors(color_index,:),'LineWidth',1.5);
%     polarplot(teta(i), 1 ,'Marker','x','MarkerEdgeColor',colors(color_index,:),'LineWidth',1.5);
% 
%     hold on,
% end
%    
% 
% %title("AOA - angle of arrival $\theta_{elevation}$ et $\theta_{azimuth}$")%%
% 
% %%
f = figure('Visible','off');
%figure(f),
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
    saveas(gcf,'C:\Users\User\Projet-S8\loc', 'png')
%% Figures
% 
% % Spectrogramme du signal reçu
% figure,
% spectrogram(test_signal, window_length, noverlap, [], fe, 'yaxis');
% title('Spectrogramme du signal reçu')
% 
% % Binarisation
% figure,
% imagesc(t,f,spect_binarise)
% colormap("gray");
% axis xy;
% xlabel('Time (s)');
% ylabel('Frequency (Hz)');
% colorbar;
% title('Spectrogramme du signal binarisé')
% 
% % filtrage (filtre PB et PH + décimation)
% figure,pwelch(nonzeros(signaux_classifications(:,3)));
% title('signal 1: DSSS')
% figure,pwelch(nonzeros(signaux_classifications(:,2)));
% title('signal 2: FM')
% figure,pwelch(nonzeros(signaux_classifications(:,4)));
% title('signal 3: AM')
% figure,pwelch(nonzeros(signaux_classifications(:,1)));
% title('signal 4: PM')
% figure,pwelch(nonzeros(signaux_classifications(:,8)));
% title('signal 5: Radar Pulse')
% figure,pwelch(nonzeros(signaux_classifications(:,5)));
% title('signal 6: CW')
% figure,pwelch(nonzeros(signaux_classifications(:,7)));
% title('signal 7: FMCW')
% 
% % figure,
% % subplot(1,2,1)
% % plot(nonzeros(signaux(:,1)))
% % xlim([0, 1500]);
% % title('Signal DSSS émis seul')
% % axis xy;
% % xlabel('Temps (s)');
% % ylabel('Amplitude ');
% 
% % subplot(1,2,2)
% % plot(nonzeros(signal_low_all(:,3)))
% % % xlim([720, 920]);
% % title('Signal DSSS obtenu après filtrage')
% % axis xy;
% % xlabel('Temps (s)');
% % ylabel('Amplitude ');
% % 
% % 
% % figure,
% % subplot(1,2,1)
% % plot(nonzeros(signaux(:,7)))
% % title('Signal FMCW émis seul')
% % xlim([0 120])
% % axis xy;
% % xlabel('Temps (s)');
% % ylabel('Amplitude ');
% % 
% % subplot(1,2,2)
% % plot(nonzeros(signal_high_all(:,3)))
% % % xlim([900 950])
% % title('Signal FMCW obtenu après filtrage')
% % axis xy;
% % xlabel('Temps (s)');
% % ylabel('Amplitude ');
% % 
% % 
% % 
% % figure,
% % subplot(1,2,1)
% % plot(nonzeros(signaux(:,6)))
% % title('Signal CW émis seul')
% % xlim([2750, 2850])
% % axis xy;
% % xlabel('Temps (s)');
% % ylabel('Amplitude ');
% % 
% % subplot(1,2,2)
% % plot(nonzeros(signal_high_all(:,7)))
% % % xlim([350, 500])
% % title('Signal CW obtenu après filtrage')
% % axis xy;
% % xlabel('Temps (s)');
% % ylabel('Amplitude ');
% 
% 
