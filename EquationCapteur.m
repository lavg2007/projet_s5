%% Sortie 3 équations pour le capteur
clc
close all
clear all

load('capteur.mat')

figure()
plot(distance, voltage)
title('Voltage p/r à distance expérimentale')
xlabel('Distance (m)')
ylabel('Voltage')

%% logarithme (code pas utile)
close all
clear all
clc

load('capteur.mat')

xn = distance(1:end-1)
yn = voltage(1:end-1)
N = length(distance)-1


X = log(xn)
Y = yn;

A = [N, sum(X)
    sum(X), sum(X.^2)]

B = [sum(Y)
    sum(Y.*X)]

test = inv(A)*B

b = test(1)
m = test(2)

alpha = b
Beta = m

yfinal = alpha +Beta*log(xn);

figure()
plot(xn,yn, 'p', xn, yfinal)

E = sum((yfinal-yn).^2)

%% Exponentiel (code utile)

close all
clear all
clc

load('capteur.mat')

xn = exp(distance)
yn = voltage
N = length(distance)-1


X = xn(1:end-1)
Y = yn(1:end-1)

A = [N, sum(X)
    sum(X), sum(X.^2)]

B = [sum(Y)
    sum(Y.*X)]

test = inv(A)*B

b = test(1)
m = test(2)

alpha = m
Beta = b

yfinal = alpha*exp(distance)+Beta;

figure()
plot(distance, voltage, 'p', distance, yfinal)
title('Fonction Exponentiel à 2 paramètres')
xlabel('Distance (m)')
ylabel('Tension (V)')

E = sum(((yn-yfinal)).^2)
RMS = sqrt((1/(N+1))*E)
Y_moy = sum(voltage)/length(voltage)
R2 = sum((yfinal-Y_moy).^2)/sum((voltage-Y_moy).^2)

%% Test voir quelle fonction a le bon style de courbe (code pas utile)

close all
clear all
clc

load('capteur.mat')
xn = 0:0.0001:0.03
x = distance
y = voltage
N = length(distance)d

a = -1e-13
b = 2.3-a
yExp = a*exp(1000*x)+b;

figure()
hold on

plot(x,y, 'p')
plot(x, yExp, 'p')

E = sum(((y-yExp)./y).^2)
RMS = sqrt((1/(N))*E)

%Résultat : 
%expotentiel -50*exp(x)+52.3 donc une courbe semblable, mais fuck all
%precis

%log non
%cosinus quand même : 2.3*cosd(2500*x)
%inverse non (a +(b/x))
%(0.26*x./(x-0.032))+2.3, quand même

%% Trouver les paramètres exact pour (0.26*x./(x-0.032))+2.27 (code utile)


%On sait que à x=0, y = 2.27 donc c = 2.27
%Mais il faut max 2 variable pour la linéarisation donc a et b
%j'enleve 2.27 au donné pour enlver le 2.27 de mon équation

close all
clear all
clc

load('capteur.mat')

vAjuster = voltage -2.27
N = length(distance)-1

X = vAjuster(1:end-1)./distance(1:end-1)
Y = vAjuster(1:end-1)

A = [N, sum(X)
    sum(X), sum(X.^2)]

B = [sum(Y)
    sum(Y.*X)]

test = inv(A)*B

b = test(1)
m = test(2)

a = b
Beta = -m

yout = (a*distance./(distance+Beta))+2.27

RMS = sqrt((1/(N+1))*sum((yout-voltage).^2))
Y_moy = sum(voltage)/N
R2 = sum((yout-Y_moy).^2)/sum((voltage-Y_moy).^2)

figure()
hold on
plot(distance, voltage, 'p')
plot(distance, yout)
title('Fonction Inverse à 2 paramètres')
xlabel('Distance (m)')
ylabel('Tension (V)')

%% Calculer des paramètres du cos (code utile)
% Fonction, les valeur de a et b ont été trouver
close all
clear all
clc

load('capteur.mat')

a = 2.5:0.01:2.8
b = 2400:1:2700

A = length(a)
B = length(b)

temp = ones(A,B,1128);
somme = 0
RMS = ones(A,B);
for i=1:length(a)
    for j=1:length(b)
    temp(i,j,:) = a(i)*cosd(b(j)*distance);
        for k=1:1128
            somme = (temp(i,j,k)-voltage(k)).^2 +somme;
        end
    RMS(i,j) = sqrt((1/1128)*somme);
    somme = 0;
    end  
end
mini = min(RMS,[], 2)
optimal = min(mini)
[row, col] = find(RMS==optimal)
RMS(row, col)

Alpha = a(row)
Beta = b(col)
out = Alpha*cosd(Beta*distance);

Y_moy = sum(voltage)/length(voltage)
R2 = sum((out-Y_moy).^2)/sum((voltage-Y_moy).^2)

figure()
hold on
plot(distance, voltage, 'p')
plot(distance, out)
title('Fonction cosinus à 2 paramètres')
xlabel('Distance (m)')
ylabel('Tension (V)')


%% Essayer de faire une fft (code pas utile)

close all
clear all
clc
xn = 0:1:1127;
load('capteur.mat')

%Copier de Matlab
Fs = 1/(sum(distance)/length(distance));      % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = length(distance); % Length of signal
t = (0:L-1)*T;        % Time vector

test = fft(voltage);

amplitude = abs(test(1:L/2));
phase = angle(test(1:L/2));
out = zeros(L/2,1128);
bob = zeros(L,1);

freq = Fs/(L/2) %Fréquence de chaque harmonique


%Ajouter du site de matlab
P2 = abs(test/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L
n = 200
bob = amplitude(n).*sin((distance).*freq.*(n-1)+phase(n))

% for j=2:L/2
%     ph = phase(j);
%     out(j:j,:) = amplitude(j).*sin(distance.*freq.*j+ph);
% %     disp('rendu la');
%     bob = amplitude(j).*sin(distance.*freq.*(j-1)+phase(j)) + bob;
% end
maybe = sum(out,1);
figure()
hold on
plot(distance,voltage, 'p')
% plot(xn, maybe)
plot(distance, bob, 'p')

%% Calculer des paramètres du cos (code utile)
% Tentative pour trouver les 4 paramètres
close all
clear all
clc

load('capteur.mat')

a = 6:0.1:7;
b = 2250:1:2400;
c = -28:1:-20;
d = -5:0.1:-4;


A = length(a);
B = length(b);
C = length(c);
D = length(d);

temp = ones(D,C,A,B,1128);
somme = 0;
RMS = ones(D,C,A,B);
for g=1:D
    for l=1:C
       for i=1:A
           for j=1:B
            temp(g,l,i,j,:) = a(i)*cosd(b(j)*distance+c(l))+d(g);
               for k=1:1128
                    somme = (temp(g,l,i,j,k)-voltage(k)).^2 +somme;
                end
           RMS(g,l,i,j) = sqrt((1/1128)*somme);
           somme = 0;
           end  
        end
    end
end

disp('RMS calculé')


[minval, minidx] = min(RMS(:));
[w, x, y, z] = ind2sub( size(RMS), minidx );

disp('méthode 2 ok')


Alpha = a(y)
Beta = b(z)
Charlie = c(x)
Delta = d(w)
minval

out = a(y)*cosd(b(z)*distance+c(x))+d(w);

Y_moy = sum(voltage)/length(voltage)
R2 = sum((out-Y_moy).^2)/sum((voltage-Y_moy).^2)

disp('Affichage')

figure()
plot(distance, voltage, 'p')
hold on
plot(distance, out)
title('Fonction cosinus à 4 paramètres')
xlabel('Distance (m)')
ylabel('Tension (V)')


%% Calculer des paramètres avec exp (code pas utile)
% Tentative pour trouver les 4 paramètres
close all
clear all
clc

load('capteur.mat')

a = -10:1:10;
b = -10:10:200;
c = -0.1:0.01:0.1;
d = 0:1:20;


A = length(a);
B = length(b);
C = length(c);
D = length(d);

temp = ones(D,C,A,B,1128);
somme = 0;
RMS = ones(D,C,A,B);
for g=1:D
    for l=1:C
       for i=1:A
           for j=1:B
            temp(g,l,i,j,:) = a(i)*exp(b(j)*distance+c(l))+d(g);
               for k=1:1128
                    somme = (temp(g,l,i,j,k)-voltage(k)).^2 +somme;
                end
           RMS(g,l,i,j) = sqrt((1/1128)*somme);
           somme = 0;
           end  
        end
    end
end

disp('RMS calculé')


[minval, minidx] = min(RMS(:));
[w, x, y, z] = ind2sub( size(RMS), minidx );

disp('méthode 2 ok')


Alpha = a(y)
Beta = b(z)
Charlie = c(x)
Delta = d(w)
minval

out = a(y)*cosd(b(z)*distance+c(x))+d(w);

Y_moy = sum(voltage)/length(voltage)
R2 = sum((out-Y_moy).^2)/sum((voltage-Y_moy).^2)

disp('Affichage')

figure()
plot(distance, voltage, 'p')
hold on
plot(distance, out)
title('Fonction cosinus à 4 paramètres')
xlabel('Distance (m)')
ylabel('Tension (V)')







