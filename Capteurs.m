%% mesures avec -1A

%%

% Taylor, Fourier, sinus, exponentielle,...

%% A MODIFIER, A ETE FAIT AVEC UN POLYNOME MAIS NE DOIS PAS L'AVOIR ETE
load('capteur.mat')
 
d1 = distance;
d0 = d1.^0;
d2 = d1.^2;
d3 = d1.^3;
d4 = d1.^4;

Y1 = voltage;
X1 = [d0 d1 d2 d3 d4];

a = pinv(X1)*Y1;
a0 = a(1);
a1 = a(2);
a2 = a(3);
a3 = a(4);
a4 = a(5);

V = a0*d0 + a1*d1 + a2*d2 + a3*d3 + a4*d4;

figure(1)
hold on
% plot(distance,V)
plot(distance,voltage)
% legend('Simulation selon les valeurs calculees','Simulation selon les valeurs mesurees')
hold off
