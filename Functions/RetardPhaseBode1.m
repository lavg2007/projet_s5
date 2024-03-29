%**************************************************************************
% 
% Fichier: RetardPhaseBode1.m
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
% R�sum�: Permet la conception d'un compensateur a retard de phase � l'aide
% des valeurs d�sir�es de vitesse angulaire, d'erreur en r�gime permanant
% et de marge.
% 
% Entr�s:  FTBO -> Une fonction de transfert en boucle ouverte
%          erp_s -> Erreur en r�gime permanent d�sir�e
%          wg_s -> Vitesse angulaire d�sir�e
%          marge -> Marge d�sir�e
% 
% Sortie:  Gr -> Fonction de transfert du compensateur � retard de phase.
% 
%**************************************************************************

function [ Gr ] = RetardPhaseBode1( FTBO, erp_s, wg_s, marge )

classe  = getClasse(FTBO);

Kvel_s = 1/erp_s;
Kvel = FTBO.Numerator{:}(end)/FTBO.Denominator{:}(end-classe);
K_s = Kvel_s/Kvel;

att = (norm(polyval(FTBO.Numerator{:},1i*wg_s)/polyval(FTBO.Denominator{:},1i*wg_s)));

if att == 1
    B = K_s;
else
    [numK_s, denK_s] = tfdata(FTBO*K_s,'v');
    B = (norm(polyval(numK_s,1i*wg_s)/polyval(denK_s,1i*wg_s)));
end
B;

T = marge/wg_s;

z = -1/T;
p = -1/(B*T);
Kr = K_s/B;

Gr = tf([1 -z],[1 -p]);
Gr = Gr*Kr;

end

