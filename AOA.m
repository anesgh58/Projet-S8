close all;
clear;
clc,

%% Données d'entrée
Ns = 3;      % Nbre maximal de signaux reçus
Na = 3;     % Nbre d'antenne de réception
d = 1;    % Distance en mètre
c = 3e8; % célérité de la lumière dans le vide m/s

fp11 = 2.3;
fp12 = fp11;
fp21 = 4.5;
fp22 = fp21;
fp31 = 5.6;
fp32 = fp31;
fp13 = fp12;
fp33 = fp31;
ti_11 = 0.9;
tf_11 = 1.6;
ti_21 = 1.1;
tf_21 = 1.5;
ti_12 = 2.1;
tf_12 = 2.8;
ti_22 = 2.2;
tf_22 = 2.6;
ti_31 = 4.1;
tf_31 = 4.2;
ti_32 = 4.2;
tf_32 = 4.3;
ti_13 = 3.1;
tf_13 = 3.8;
ti_23 = 0.1; 
tf_23 = 0.5;
ti_33 = 5.5; 
tf_33 = 5.7;

A1 = [1,fp11, ti_11, tf_11; 2, fp21, ti_21, tf_21; 3, fp31, ti_31, tf_31];
A2 = [1,fp12, ti_12, tf_12; 2, fp22, ti_22, tf_22; 3, fp32, ti_32, tf_32];
A3 = [1,fp13, ti_13, tf_13; 2, fp31, ti_23, tf_23; 3, fp33, ti_33, tf_33];

A = [A1 A2 A3];

[x, y] = size(A);

teta = zeros(1,x);
gama = zeros(1,x);

for j = 1:x
    dec_temp = abs(A(j,3) - A(j,7))*1e-9;
    teta_d = acosd(c*dec_temp/d);
    teta(j) = mod(teta_d,360);
    dec_temp2 = abs(A(j,7) - A(j,11))*1e-9;
    gama_d = acosd(c*dec_temp2/d); 
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
lat_sat = 48.8566;
lon_sat = 2.3522;
alt_sat = 550000; % altitude du satellite au-dessus du niveau de la mer (en mètres)
lat  = zeros(1,x);
lon = zeros(1,x);
alt = zeros(1,x);
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
    z_sat = (R*(1-e^2) + alt_sat) * sin(lat_sat_rad); % coordonnée z du satellite (en mètres)
    
    % Calcul de la distance entre le point d'intérêt et le satellite (en mètres)
    d = R/sqrt(1 - e^2*sin(lat_sat_rad)^2) * sin(elev);
    
    % Calcul des coordonnées cartésiennes du point d'intérêt
    x_p = x_sat + d*cos(az)*cos(elev);
    y_p = y_sat + d*sin(az)*cos(elev);
    z_p = z_sat + d*sin(elev);
    
    % Conversion en coordonnées géographiques
    lat(i) = asin(z_p/sqrt(x_p^2 + y_p^2 + z_p^2)) * 180/pi; % latitude (en degrés)
    lon(i) = atan2(y_p, x_p) * 180/pi; % longitude (en degrés)
    alt(i) = sqrt(x_p^2 + y_p^2 + z_p^2) - R; % altitude au-dessus du niveau de la mer (en mètres)
end

% Création de la carte
figure
geoplot(0,0) % carte du monde
%geolimits([47 50],[1 4]) % limites de la carte
% Ajout des points sur la carte
hold on, 
geoscatter(lat(1),lon(1), 'x','LineWidth',1.5) % premier point en bleu
geoscatter(lat(2),lon(2), 'x','LineWidth',1.5) % deuxième point en rouge
geoscatter(lat(3),lon(3), 'x','LineWidth',1.5) % deuxième point en rouge
% Légende
legend('','Signal 1', 'Signal 2', 'Signal 3')
geobasemap streets-light % fond de carte