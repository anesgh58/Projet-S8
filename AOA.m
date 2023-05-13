close all;
clear;
clc,

%% Données d'entrée
Ns = 3;      % Nbre maximal de signaux reçus
Na = 3;     % Nbre d'antenne de réception
c = 3e8; % célérité de la lumière dans le vide m/s

load A1.mat
load A2.mat
load A3.mat
load A.mat
load d.mat
A = [A1 A2 A3];

[x, y] = size(A);

teta = zeros(1,x);
gama = zeros(1,x);

for j = 1:x
    dec_temp = A(j,3) - A(j,7);
    teta_d = acosd(c*dec_temp/d(1));
    teta(j) = mod(teta_d,360);
    dec_temp2 = A(j,7) - A(j,11);
    gama_d = acosd(c*dec_temp2/d(2)); 
    gama(j) = mod(gama_d,360);
end

polarplot(gama(1), 1 ,'bx','LineWidth',1.5); 
hold on, 
polarplot([teta(1)], 1 ,'b*','LineWidth',1.5); 
polarplot([gama(2)], 1 ,'rx','LineWidth',1.5); 
polarplot([teta(2)], 1 ,'r*','LineWidth',1.5); 
polarplot([gama(3)], 1 ,'gx','LineWidth',1.5); 
polarplot([teta(3)], 1 ,'g*','LineWidth',1.5); 
polarplot(0, 0, 'kx','LineWidth',1.5)
set(0, 'defaulttextInterpreter', 'latex')
legend({'Signal 1 - angle d''arrivée \theta', 'Signal 1 - angle d''arrivée \gamma', ...
    'Signal 2 - angle d''arrivée \theta', 'Signal 2 - angle d''arrivée \gamma', ...
    'Signal 3 - angle d''arrivée \theta', 'Signal 3 - angle d''arrivée \gamma'});
title("AOA - angle d'arriv\'{e}e $\theta$ et $\gamma$")



%%
% Coordonnées géographiques du satellite (en degrés)
lat_sat = 46;
lon_sat = 2;
alt_sat = 550000; % altitude du satellite au-dessus du niveau de la mer (en mètres)
lat  = zeros(1,x);
lon = zeros(1,x);
alt = zeros(1,x);
K = -3:3;

for k = K
    for j = K
    gama = teta + 90*k;
    teta = gama + 90*j;
        for i = 1:x
            % Angle d'élévation et d'azimut pour le point d'intérêt (en radians)
            elev = teta(i); % angle d'élévation
            az = gama(i); % angle d'azimut
            
            % Conversion en coordonnées cartésiennes
            R = 6378137; % rayon de la Terre (en mètres)
            e = 0.0818191908426; % excentricité de l'ellipsoïde terrestre
            
            lat_sat_rad = lat_sat * pi/180; % latitude du satellite (en radians)
            lon_sat_rad = lon_sat * pi/180; % longitude du satellite (en radians)
            
            x_sat = (R + alt_sat) * cos(lat_sat_rad) * cos(lon_sat_rad); % coordonnée x du satellite (en mètres)
            y_sat = (R + alt_sat) * cos(lat_sat_rad) * sin(lon_sat_rad); % coordonnée y du satellite (en mètres)
            %z_sat = (R + alt_sat) * sin(lat_sat_rad); % coordonnée z du satellite (en mètres)
            z_sat = (R*(1-e^2) + alt_sat) * sin(lat_sat_rad); % coordonnée z du satellite (en mètres)
            
            % Calcul de la distance entre le point d'intérêt et le satellite (en mètres)
            d = R/10*sqrt(1 - e^2*sin(lat_sat_rad)^2) * sin(elev);
        %     % Calcul de la distance entre le point d'intérêt et le satellite (en mètres)
        %     d = R/sqrt(1 - sin(lat_sat_rad)^2) * sin(elev);
        %     %distance = sqrt((x_point - x_sat)^2 + (y_point - y_sat)^2 + (z_point - z_sat)^2)
            t = d/c;
            % Calcul des coordonnées cartésiennes du point d'intérêt
            x_p = x_sat + d*cos(az)*cos(elev);
            y_p = y_sat + d*sin(az)*cos(elev);
            z_p = z_sat + d*sin(elev);
            
            % Conversion en coordonnées géographiques
            lat(i) = asin(z_p/sqrt(x_p^2 + y_p^2 + z_p^2)) * 180/pi; % latitude (en degrés)
            lon(i) = atan2(y_p, x_p) * 180/pi; % longitude (en degrés)
            alt(i) = sqrt(x_p^2 + y_p^2 + z_p^2) - R; % altitude au-dessus du niveau de la mer (en mètres)

        if (abs(coord_Tx(i,1) - lat(i)) < 0.5) && (abs(coord_Tx(i,2) - lon(i)) < 0.5)
            
            lati(i) = lat(i);
            longi(i) = lon(i);
            
        end

        end

       
    end
end

        % Création de la carte
    figure,
    geoplot(0,0) % carte du monde
    geolimits([42 52],[-2 7]) % limites de la carte
    % Ajout des points sur la carte
    hold on, 
geoscatter(lati,longi, 'x','LineWidth',1.5) ;
geoscatter(coord_Tx(:,1),coord_Tx(:,2), 'o');
geobasemap streets-light  % fond de carte

