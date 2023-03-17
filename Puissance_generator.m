function[Pr] = Puissance_generator(Ptx,f,B,vpos1,vpos2)

%Ptx: Puissance d'émission du signal
%f: fréquence d'émission
%B: le bruit

%Changer par un vecteur
%x1,y1,z1: altitude, longitude et latitude de satellite
%x2,y2,z2: altitude, longitude et latitude de l'émetteur du signal

%Hypothèse sur le gain d'une antenne isotrope idéale:
Grx=2.15;

%Vitesse de la lumière
c=physconst('LightSpeed');

%Constante de Boltzmann
k=physconst('Blotzmann');

%Calcul de la longueur d'onde
lambc=c/f;

%Calcul de la distance
diff=vpos2-vpos1;
D=norm(diff);

%Calcul de EIRP
EIRP = Ptx + Grx;

%Calcul du pathloss
PL = 10*log10((lambc/(4*pi*D)));

%Calcul de la puissance du bruit
Pb = k*To*B;

%Calcul de la puissance reçue
Pr = EIRP-PL-Pb;