% Lire le fichier SVG
I = imread('C:\Users\User\Desktop\Départements_de_France-simple.jpg');


% Créer une image masque transparente
mask = zeros(size(I,1), size(I,2), 'uint8');
center = [size(I,2)/2, size(I,1)/2]; % Calculer le centre de l'image
radius = 1300; % Définir le rayon du cercle
mask = insertShape(mask, 'FilledCircle', [center(1) center(2) radius], 'Opacity', 0.7, 'Color', 'white'); % Remplir le cercle avec de la transparence


% Combiner l'image d'origine avec la masque
I2 = imfuse(I, mask, 'blend'); % ou utiliser imoverlay(I, mask)

% Afficher l'image sur un axe de figure
imshow(I2);

% Ajouter un disque rouge transparent au centre de l'image
center = [size(I,2)/2, size(I,1)/2]; % Calculer le centre de l'image
radius = 10; % Définir le rayon du disque
viscircles(center, radius, 'Color', 'r'); % Afficher le disque




