function [longi, lati, teta, gama] = AOA_function(A1,A2,A3, d,c, coord_Tx)
    A = [A1 A2 A3];
    
    [x, ~] = size(A);
    
    teta = zeros(1,x);
    gama = zeros(1,x);
    
    for j = 1:x
        dec_temp = abs(A(j,3) - A(j,7));
        teta_d = acosd(c*dec_temp/d(2));
        teta(j) = mod(teta_d,360);
        dec_temp2 = abs(A(j,7) - A(j,11));
        gama_d = acosd(c*dec_temp2/d(1)); 
        gama(j) = mod(gama_d,360);
    end
    
    
%     polarplot(0, 0 ,'kx','LineWidth',1.5);
%     hold on, 
%     for i = 1:length(teta)
%         polarplot([gama(i) teta(i)], [1 1] ,'x','LineWidth',1.5);
%     end
%     title("AOA - angle d'arriv\'{e}e $\theta$ et $\gamma$")
%     
    
    %%
    % Coordonnées géographiques du satellite (en degrés)
    lat_sat = 42;
    lon_sat = 2;
    alt_sat = 550000; % altitude du satellite au-dessus du niveau de la mer (en mètres)
    lat  = zeros(1,x);
    lon = zeros(1,x);
    alt = zeros(1,x);
    K = -3:3;
    lati = zeros(1,x);
    longi = zeros(1,x);
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

        if (abs(coord_Tx(i,1) - lat(i)) < 0.2) && (abs(coord_Tx(i,2) - lon(i)) < 0.2)
            
            lati(i) = lat(i);
            longi(i) = lon(i);
            
        end

        end

       
    end
end
    
end
