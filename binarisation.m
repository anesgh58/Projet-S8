function [signal] = binarisation(signal,seuil)

mask = signal > seuil;

% figure;
% plot(segment);
% hold on;
% plot(seuil * ones(1, length(segment)));
% legend("intensité", "seuil");
% grid on;
% title("Intensité sur le segment selectionné");
% hold off;

signal(mask) = 1;
signal(~mask) = 0;
end


