%**************************************************************************
% 
% Fichier: ProportionnelIntegralBode.m
% Date: 2019-12-03
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
% R�sum�: Permet la conception d'un compensateur proportionnel int�gral
% selon la vitesse angulaire.
% 
% Entr�s:  FTBO -> Une fonction de transfert en boucle ouverte
%          wg -> Vitesse angulaire d�sir�e
%          facteur -> Valeur arbitraire vue en classe
% 
% Sortie:  Gr -> Fonction de transfert du compensateur PI
% 
%**************************************************************************

function [ Gr ] = ProportionnelIntegralBode( FTBO,wg,facteur )
%Compensateur PI avec Bode
%   Prend le K de la classe actuelle (Kpos ou Kvel), l'erreur en RP de la
%   nouvelle classe et s
%   [ Gr ] = ProportionnelIntegralV2( K_ini,erp,s,facteur )

[num,den] = tfdata(FTBO,'v');

z = -wg/facteur;

Kp = 1/norm(((wg*1i)-z)/((wg*1i)));

G2 = tf([1 -z],[1 0]);
Gr = Kp*G2;

end


