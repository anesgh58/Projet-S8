function [signal_output] = upscale(signal_input,fe,fe_signal,len, time,PRx)
   
    signal_upsampled = upsample(signal_input,round(fe/fe_signal));   % upsampling
    signal_interp = interpolation(signal_upsampled);
    signal_output = zeros(1,int32(len));
    size = [1,time:length(signal_interp)+time-1];
    if (length(size) > len) || (time + length(size)>len)
        signal_output(1,time:end) = signal_interp(1:len-time+1);

    else
    signal_output(1,time:length(signal_interp)+time-1) = signal_interp;
    end
    signal_output = (signal_output * PRx).';              % multiplication par la puissance du signal

end

% %     elseif (difference < length(signal_interp))
%         signal_output(1,time:len) = signal_interp(1:);

%     difference = len-length(time:length(signal_interp)+time-1);


%     filter_coeffs = fir1(32, 2*1e6/fe, 'low');
%     signal_upsampled = conv(signal_upsampled,filter_coeffs);
%     Te = 1/fe;
%     t = 0:Te:(length(signal_upsampled)-1)*Te; 
%     signal_interp = conv(signal_upsampled.* hamming(length(signal_upsampled)).',sinc(pi*fe*t),'same');                   % sinc interpolation


%  elseif difference < length(signal_interp)
%        signal_output(1,time:length(signal_interp)+time-1) = signal_interp(1:difference);