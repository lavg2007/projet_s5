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

