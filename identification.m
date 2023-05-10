function [f_p,t_emission,t_reception] = identification(spect_binarise,t,f)

    % Algorithme de labelisation
    [label,index] = bwlabel(spect_binarise,8) ;
    f_p = zeros(1,double(index));
    t_emission = zeros(1,double(index));
    t_reception = zeros(1,double(index));
    
    for i=1:index   
        zone = (label==i);
        [f_p(i),t_emission(i),t_reception(i)] = barycentre(zone,t,f);
    end
end

