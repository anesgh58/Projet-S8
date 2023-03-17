function [s,t] = FMCW(T_i,T_f, Te, B, f )
    T = T_f-T_i; 
    t = 0:Te:T; % Vecteur de temps
    s = cos(2*pi*(f*t + B*(t.^2)/(2*T)));
    
end