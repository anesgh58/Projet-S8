function [signal_low_all,signal_high_all,B] = filtrage(N,signal,B,h_low,h_high,bandwith_signal,i,signal_low_all,signal_high_all)

if B >  10 * bandwith_signal
    filtered_signal_low_1 = conv(signal, h_low, 'same');
    filtered_signal_high_1 = conv(signal, h_high, 'same');
    signal_low = filtered_signal_low_1(1:2:end);
    signal_high = filtered_signal_high_1(1:2:end);

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


  [signal_low_all,signal_high_all,~] = filtrage(N,signal_low,B/2,h_low,h_high,bandwith_signal,i+1,signal_low_all,signal_high_all);
  [signal_low_all,signal_high_all,~] = filtrage(N,signal_high,B/2,h_low,h_high,bandwith_signal,i+1,signal_low_all,signal_high_all);
    
end
end

