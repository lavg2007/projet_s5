%**************************************************************************
% 
% Fichier: ProportionnelIntegralV1.m
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
% R�sum�: Calcul d'un compensateur proportionnel int�gral (PI)
% 
% Entr�s:  FTBO -> Une fonction de transfert en boucle ouverte
%          s -> un angle (en degr�e)
%          marge -> valeur num�rique de la marge de phase d�sir�
% 
% Sortie:  Gpi -> Fonction de transfert du compensateur PI
% 
%**************************************************************************

function [ Gpi ] = ProportionnelIntegralV1( FTBO,s,marge )
%Compensateur PI version simple
%   [ Gpi ] = ProportionnelIntegralV1( num,den,s )

[num,den] = tfdata(FTBO,'v');

z = real(s(1))/marge;

Kr = 1/norm((s(1)-z)/(s(1))*(polyval(num,s(1))/polyval(den,s(1))));

% if ((0.9 > Kr) || (1.1 < Kr))
%     disp(['Kr non unitaire ',num2str(Kr)])
% end

Kr = 1;

G = tf([1 -z],[1 0]);
Gpi = Kr*G;

end


