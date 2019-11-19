function [ Ga ] = AvancePhaseBode2( FTBO, erp_s, PM_s, att )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

classe  = getClasse(FTBO);

Kvel_s = 1/erp_s;
Kvel = FTBO.Numerator{:}(end)/FTBO.Denominator{:}(end-classe);
K_s = Kvel_s/Kvel;


[GM_Ks,PM_Ks,wp_Ks,Wg_Ks] = margin(K_s*FTBO);

deltaphi  = PM_s - PM_Ks + att;

a = (1-sind(deltaphi))/(1+sind(deltaphi));

% A la place, de trouver a la mitaine, je peux calculer avec margin
%gain = -20*log10(1/sqrt(a));
[GM_sa,PM_sa,wp_sa,wg_sa] = margin(K_s*FTBO/sqrt(a));

T = 1/(wg_sa*sqrt(a));

z = -1/T;
p = -1/(a*T);
Ka = K_s/a;

Ga = tf([1 -z],[1 -p])*Ka;


end

