%**************************************************************************
% 
% Fichier: DoubleAvanceDePhase.m
% Date: 2019-12-02
% Universit� de Sherbrooke - G�nie �lectrique
% 
% �quipe P4:
%           Brittany Latour - latb2901 
%           Samuel Mathieu - mats2510 
%           Jacob Fortin - forj1928 
%           Gabriel Lavoie - lavg2007 
%           Olivier Chr�tien-Rioux - chro2901 
%           Sarah Clauzade - clas2902 
%           Thierry Letalnet - lett2101 
%
% R�sum�: Calcul d'une fonction permettant une double avance de phase.
% 
% Entr�s:  FTBO -> Une fonction de transfert en boucle ouverte
%          phi -> un angle (en degr�e)
%          Wn -> une vitesse angulaire
%          zeta -> un angle (en degr�e)
%          Wa -> une vitesse angulaire
%          s -> un angle (en degr�e)
%          ajustement -> valeur num�rique d�sir�
% 
% Sortie:  Ga -> Fonction de transfert ajuster
% 
%**************************************************************************

function [ Ga ] = DoubleAvanceDePhase( FTBO,phi,Wn,zeta,Wa,s,ajustement )
%Compensateur avance de phase
%   [ G, Ka ] = AvanceDePhase( num,den,phi,Wn,zeta,Wa,s )

[num,den] = tfdata(FTBO,'v');

z = roots(num);
p = roots(den);

phasez_sum = 0;
for i=1:length(z)
    phasez_sum = phasez_sum + angle(polyval([1 -z(i)],s));
end

phasep_sum = 0;
for i=1:length(p)
    phasep_sum = phasep_sum + angle(polyval([1 -p(i)],s));
end

phase = (phasez_sum - phasep_sum)*180/pi;
phase = phase(1);
deltaphi = (-180 - phase )
deltaphi = (-180 - phase + ajustement)/2;
alpha = 180 - phi;

phiz = (alpha+deltaphi)/2;
phip = (alpha-deltaphi)/2;

z = -zeta*Wn-Wa/tand(phiz);
p = -zeta*Wn-Wa/tand(phip);

numav = [1 -z]; 
denav = [1 -p];
G = tf(numav,denav);
G = G*G;

Ka = 1/norm(((s(1)-z)/(s(1)-p))^2*num/polyval(den,s(1)));

Ga = G*Ka;

end

