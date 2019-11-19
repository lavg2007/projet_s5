function [ Gr ] = RetardDePhase( num,den,K_s,s )
%Compensateur retard de phase
%   [ Gr ] = RetardDePhase( num,den,K_s,s )

z = real(s(1))/10
p = z/K_s

Kr = 1/norm((s(1)-z)/(s(1)-p)*(polyval(num,s(1))/polyval(den,s(1))));

if ((0.9 > Kr) || (1.1 < Kr))
    disp(['Kr non unitaire ',num2str(Kr)]);
end

Kr = 1

G = tf([1 -z],[1 -p]);
Gr = Kr*G;

end

