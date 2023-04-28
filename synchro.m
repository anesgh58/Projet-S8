function [h] = synchro(decalage)

d = -9 + decalage;

for n=1:200
h(n) = sinc(pi * (n - 10 - d)) ;
end
% decalage de 9 echantillons
if d==0
    h(isnan(h)) = 1;
end
end

% 0 9
% -1 8
% -2 7
% -3 6
% -4 5
% -5 4
% -6 3
% -7 2
% -8 1

