function [s,t] = CW(T_i,T_f, Te,f )
    T = T_f - T_i;  % Durée du signal
    t = 0:Te:T; % Vecteur de temps
    A = 1; % amplitude du signal CW
    s = A*cos(2*pi*f*t); % signal CW

end