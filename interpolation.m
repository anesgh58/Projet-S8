function [signal_interp] = interpolation(signal)

Xnz = signal(signal ~= 0);                                
vnz = find(signal ~= 0);                             
iv = 1:length(signal);                               
signal_interp = interp1(vnz, Xnz, iv, 'linear','extrap').';
end

