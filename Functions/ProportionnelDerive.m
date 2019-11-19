function [ G, Kpd ] = ProportionnelDerive( num,den,Wn,zeta,Wa,s )
%Compensateur PD
%   [ G, Kpd ] = ProportionnelDerive( num,den,Wn,zeta,Wa,s )

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
deltaphi = -180 - phase;

phiz = deltaphi;

z = -zeta*Wn-Wa/tand(phiz);

numpd = [1 -z]; 
denpd = [1];
G = tf(numpd,denpd);

Kpd = 1/norm((s(1)-z)*num/polyval(den,s(1)));

Gpd = G*Kpd;

end

