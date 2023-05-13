function distance = distance_geodesique(pos1, pos2)
% Calcule la distance géodésique entre deux points de la surface de la Terre.
% Les coordonnées sont données en degrés pour les latitudes et longitudes, et en mètres pour les altitudes.
% La distance est renvoyée en mètres.

% Rayon de la Terre en mètres
R = 6378137;

lat1 = pos1(1);
long1 = pos1(2);
alt1 = pos1(3);
lat2 = pos2(1);
long2 = pos2(2);
alt2 = pos2(3);
% Convertir les coordonnées en radians
lat1 = deg2rad(lat1);
long1 = deg2rad(long1);
alt1 = alt1 + R;
lat2 = deg2rad(lat2);
long2 = deg2rad(long2);
alt2 = alt2 + R;

% Calculer les coordonnées cartésiennes des deux points
x1 = (R + alt1) * cos(lat1) * cos(long1);
y1 = (R + alt1) * cos(lat1) * sin(long1);
z1 = (R + alt1) * sin(lat1);
x2 = (R + alt2) * cos(lat2) * cos(long2);
y2 = (R + alt2) * cos(lat2) * sin(long2);
z2 = (R + alt2) * sin(lat2);

% Calculer la distance euclidienne entre les deux points
dx = x2 - x1;
dy = y2 - y1;
dz = z2 - z1;
distance = sqrt(dx^2 + dy^2 + dz^2);
end
