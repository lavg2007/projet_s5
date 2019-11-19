function [ Gr ] = ProportionnelIntegralV2( K_ini,erp,s,facteur )
%Compensateur PI pour erreur en RP dans nouvelle classe
%   Prend le K de la classe actuelle (Kpos ou Kvel), l'erreur en RP de la
%   nouvelle classe et s
%   [ Gr ] = ProportionnelIntegralV2( K_ini,erp,s,facteur )

z = real(s(1))/facteur

Kl = 1/(K_ini*erp)
Kp = -Kl/z

G2 = tf([1 -z],[1 0]);
Gr = Kp*G2;

end


