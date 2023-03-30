function [t,f] = recherche_var(signal)

%On fait dans un premier temps une étude de la transformée de Fourrier pour
%trouver la fréquence

fft_signal=fft(signal);
abs_fft=abs(fft_signal);
f=find(max(abs_fft));

%Recherche de la durée

% Identifier la fréquence fondamentale du signal inconnu
% Définition des paramètres du spectrogramme
window_length = round(length(signal)/100); % Longueur de la fenêtre
noverlap = round(window_length/2); % Chevauchement des fenêtres

% Calcul du spectrogramme
[S,T,F]=spectrogram(signal, noverlap, [], fe, 'yaxis');

t = S;