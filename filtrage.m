function [signaux_classifications,signal_low_all,signal_high_all] = filtrage(N,signal,B,h_low,h_high,bandwith_signal,i,signal_low_all,signal_high_all)


[signal_low_all,signal_high_all,~] = recurrence(N,signal,B,h_low,h_high,bandwith_signal,i,signal_low_all,signal_high_all);


signaux_classifications = zeros(length(signal_low_all),8); % Signaux à classifier
% Signaux issues du filtre passe bas et passe haut de la derniere itération. Lecture du treillis de la gauche vers la droite
signaux_classifications(:,1) = signal_low_all(:,3);
signaux_classifications(:,2) = signal_high_all(:,3);
signaux_classifications(:,3) = signal_low_all(:,4);
signaux_classifications(:,4) = signal_high_all(:,4);
signaux_classifications(:,5) = signal_low_all(:,6);
signaux_classifications(:,6) = signal_high_all(:,6);
signaux_classifications(:,7) = signal_low_all(:,7);
signaux_classifications(:,8) = signal_high_all(:,7);

end


function [signal_low_all,signal_high_all,B] = recurrence(N,signal,B,h_low,h_high,bandwith_signal,i,signal_low_all,signal_high_all)

if B >  10 * bandwith_signal
    % Filtrage passe bas et passe haut
    filtered_signal_low_1 = conv(signal, h_low, 'same');
    filtered_signal_high_1 = conv(signal, h_high, 'same');
    % Décimation
    signal_low = filtered_signal_low_1(1:2:end);
    signal_high = filtered_signal_high_1(1:2:end);
    
    % Stockage des signaux
    if i==1
        signal_low_all(:,i) = signal_low;
        signal_high_all(:,i) = signal_high;
    else
        n = length(signal_low_all(:,1)) - length(signal_low);
        signal_low_matrice = padarray(signal_low,n,0,'post');
        signal_high_matrice = padarray(signal_high,n,0,'post');
        signal_low_all = cat(2,signal_low_all,signal_low_matrice);
        signal_high_all = cat(2,signal_high_all,signal_high_matrice);
    end

  % Récurrence pour une largeur de bande divisée par deux tant que B >  10 * bandwith_signal 
  [signal_low_all,signal_high_all,~] = recurrence(N,signal_low,B/2,h_low,h_high,bandwith_signal,i+1,signal_low_all,signal_high_all);
  [signal_low_all,signal_high_all,~] = recurrence(N,signal_high,B/2,h_low,h_high,bandwith_signal,i+1,signal_low_all,signal_high_all);
    
end
end

