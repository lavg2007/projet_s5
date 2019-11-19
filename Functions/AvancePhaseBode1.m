function [ Ga, wg_s ] = AvancePhaseBode1( FTBO, PM_s, BW_s, att )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

zeta_s = 0.5*sqrt(tand(PM_s)*sind(PM_s))
wn_s = BW_s/sqrt((1-2*zeta_s^2)+(sqrt(4*zeta_s^4-4*zeta_s^2+2)));
wg_s = 2*zeta_s*wn_s/tand(PM_s)

K_s = 1/(norm(polyval(FTBO.Numerator{:},1i*wg_s)/polyval(FTBO.Denominator{:},1i*wg_s)));

[GM_Ks,PM_Ks,wp_Ks,wg_Ks] = margin(FTBO*K_s);

if PM_Ks >= PM_s
    disp('No need for a FT, just a gain')
    Ga = K_s;
    return
end
    
PM_s
deltaphi = PM_s - PM_Ks+att

a = (1-sind(deltaphi))/(1+sind(deltaphi));

T = 1/(wg_s*sqrt(a));

z = -1/T
p = -1/(a*T)
Ka = K_s/sqrt(a)

Ga = tf([1 -z],[1 -p])
Ga = Ga * Ka
end

