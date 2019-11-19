function [ Gr ] = ProportionnelIntegral( num,den,K_s,s )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

z = real(s(1))/10;
p = z/K_s;

K = 1;
Kr = 1/norm((s(1)-z)/(s(1)-p)*(polyval(num,s(1))/polyval(den,s(1))));

if ((0.9 > Kr) || (1.1 < Kr))
    disp(['Kr non unitaire ',num2str(Kr)])
end

G2 = tf([1 -z],[1 -p]);
Gr = K*G2;

end


