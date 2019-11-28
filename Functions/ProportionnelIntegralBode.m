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


