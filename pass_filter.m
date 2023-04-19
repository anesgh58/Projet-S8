function [filter_signal] = pass_filter(signal,bandwidth,center_freq,fe)
    
    Fst1 = (center_freq - 0.5*bandwidth)/fe; % normalized stopband frequency 1
    Fp1 = (center_freq - 0.25*bandwidth)/fe; % normalized passband frequency 1
    Fp2 = (center_freq + 0.25*bandwidth)/fe; % normalized passband frequency 2
    Fst2 = (center_freq + 0.5*bandwidth)/fe; % normalized stopband frequency 2
    Ast1 = 30;                               % stopband attenuation
    Ap = 1;                                  % passband ripple
    Ast2 = 30;                               % stopband attenuation
    
    bandpass = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',Fst1, Fp1, Fp2, Fst2, Ast1, Ap, Ast2);
    hd = design(bandpass,'equiripple');
    filter_signal = filter(hd, signal);
end

