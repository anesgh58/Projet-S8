
function [frequence_porteuse,temps_emission,temps_reception] = barycentre(zone,t_axis,f_axis)
[y_zone, x_zone] = find(zone);
x_zone = unique(x_zone); y_zone = unique(y_zone);
temps = t_axis(x_zone) ;
frequence = f_axis(y_zone).';
frequence_porteuse = floor(mean(frequence));
temps_emission = min(temps);
temps_reception = max(temps);
end