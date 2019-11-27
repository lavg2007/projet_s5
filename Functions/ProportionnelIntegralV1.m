function [ Gpi ] = ProportionnelIntegralV1( num,den,s,marge )
%Compensateur PI version simple
%   [ Gpi ] = ProportionnelIntegralV1( num,den,s )

z = real(s(1))/marge;

Kr = 1/norm((s(1)-z)/(s(1))*(polyval(num,s(1))/polyval(den,s(1))));

% if ((0.9 > Kr) || (1.1 < Kr))
%     disp(['Kr non unitaire ',num2str(Kr)])
% end

Kr = 1;

G = tf([1 -z],[1 0]);
Gpi = Kr*G;

end


