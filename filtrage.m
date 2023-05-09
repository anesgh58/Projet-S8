
function [signal_low_all_1,signal_high_all_1,signal_low_all_2,signal_high_all_2,B] = filtrage(N,signal,B,h_low,h_high,bandwith_signal,i)

filtered_signal_low = signal;
filtered_signal_high = signal;

signal_low_all_1 = [];
signal_high_all_1 = [];
signal_low_all_2 = [];
signal_high_all_2 = [];

while B > bandwith_signal
    filtered_signal_low_1 = conv(filtered_signal_low, h_low, 'same');
    filtered_signal_high_1 = conv(filtered_signal_high, h_high, 'same');
    signal_low = filtered_signal_low_1(1:2:end);
    signal_high = filtered_signal_high_1(1:2:end);

    B = B/2;
    figure,
    window_length = round((length(signal_low)) /100) +1;            % Longueur de la fenêtre
    noverlap = round(window_length/2);  
    spectrogram(signal, window_length, noverlap, [], B, 'yaxis');

%     figure,
%     pwelch(signal_low)

    filtrage(N,signal_low,B,h_low,h_high,bandwith_signal,2*(i+1));
    filtrage(N,signal_high,B,h_low,h_high,bandwith_signal,2*(i+1)+1);

    if mod(i, 2) == 1
    signal_low_all_1 = vertcat(signal_low_all_1, signal_low);
    signal_high_all_1 = vertcat(signal_high_all_1, signal_high);
    end

    if mod(i, 2) == 0
    signal_low_all_2 = vertcat(signal_low_all_2, signal_low);
    signal_high_all_2 = vertcat(signal_high_all_2, signal_high);
    end
end
end

