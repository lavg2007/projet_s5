function [Pi,Ltr, E, Vr, Traj, tt, tab] = trajectoire(x,y,v,Ts)
%interpolation : Il faut que m et t soient de même taille
%   Calcul du polynome d'interpolation de la trajectoire
Pi = 1;
Ltr = 0;
E = 1;
Vr = 1;
Traj =0;
tt = 1;
tab = 1;


N = length(x);
phi(:,1) = ones(size(x));
P(:,1) = phi(:,1);
for i=2:N
    phi(:,i) = x.^(i-1);
    P(:,i) = phi(:,i);
end

Pi = inv(P) * y;

xx = linspace(x(1), x(end), 1000);

fy = Pi(1);
for j=2:N
    fy = fy + Pi(j).*xx.^(j-1);
end





%Calcul de la trajectoire

M = 101;
dx = linspace(x(1), x(end), M);

for i = 1:numel(Pi)-1
    dPi(i) = Pi(i+1)*(i);
end
df = polyval(flip(dPi),dx);
for i = 1:numel(dPi)-1
    ddPi(i) = dPi(i+1)*(i);
end
ddf = polyval(flip(ddPi),dx);

pas = (x(end)-x(1))/(M-1);

g = sqrt(1 + (df).^2);

for i=2:M
    Ltr(i) = pas/2*( g(1) + g(i) + 2*sum(g(2:1:i-1)));
end

% Calcul de l'erreur
dg = df.*ddf./g;
E  = (pas^2/12)*(dg(end) - dg(1));

%Calcul de O et vitesse réel

d = v/Ts;
O = round(Ltr(end)./(v*Ts) +1);
Vr = Ltr(end)/(Ts*(O-1));

% %Newton-Raphson


Leq = Ltr(end)/(O-1);
an = x(1);
X(1) = an;
for i=2:O
    bn = an + 0.01;
    xn = linspace(an, bn, M);
    dfn = polyval(flip(dPi),xn);
    gn = sqrt(1 + (dfn).^2);
    pasn = (xn(end)-xn(1))/(M-1);
    Ltrn = pasn/2*( gn(1) + gn(end) + 2*sum(gn(2:1:end-1)));
    fn = Ltrn - Leq;
    dn= gn(end);
    it1 = 0;
    tol = 1e-8;

    while abs(fn)>tol && it1<501
        bn = bn - fn/dn;
        xn = linspace(an, bn, M);
        dfn = polyval(flip(dPi),xn);
        gn = sqrt(1 + (dfn).^2);
        pasn = (xn(end)-xn(1))/(M-1);
        Ltrn = pasn/2*( gn(1) + gn(end) + 2*sum(gn(2:1:end-1)));
        fn = Ltrn - Leq;
        dn= gn(end);    
        it1 = it1 +1;
    end
    X(i) = bn;
    an = bn;

end
Y = polyval(flip(Pi),X);

figure
hold on
plot(x,y,'o')
plot(xx, fy)
plot(X,Y,'s')

Traj = [X' Y'];
tt = Ltr(end)/Vr;
Ltr = [dx' Ltr'];

end













