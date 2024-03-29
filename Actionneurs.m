reset = 1;

if reset
   close all
   clear all
   clc
end

% figure 1:   Simulation avec -1A
% figure 2:   Simulation avec -2A
% figure 3:   Simulation avec -1A mesure et coefficient moyens
% figure 4:   Simulation avec -2A mesure et coefficient moyens
% figure 5:   Simulation pour Fs
% figure 6:    
% figure 7:   
% figure 8:   
% figure 9:   
% figure 10:   
%figures    1 2 3 4 5 6 7 8 9 10
figures = [ 1 0 0 0 0 1 1 0 0 0];           %Mettre 1 pour afficher et 0 pour cacher

% displays 1:   Erreur sur -1A
% displays 2:   Erreur sur -2A
% displays 3:   Choix des coefficients Fe
% displays 4:   Erreur sur Fs
% displays 5:   Choix des coefficients Fs
% displays 6:
% displays 7:   
% displays 8:   
% displays 9:   
% displays 10:   
%displays    1 2 3 4 5 6 7 8 9 10
displays = [ 0 0 0 0 0 0 0 0 0 0];          %Mettre 1 pour afficher et 0 pour cacher

%% mesures avec -1A

load('Fe_attraction.mat')

I1 = -1;
be1 = 13.029359254409743;

z1_1 = z_m1A;
z1_0 = z1_1.^0;
z1_2 = z1_1.^2;
z1_3 = z1_1.^3;

Y1 = ((I1^2+be1*abs(I1))*sign(I1))./Fe_m1A;

X1 = [z1_0 z1_1 z1_2 z1_3];

a1 = pinv(X1)*Y1;
ae1_0 = a1(1);
ae1_1 = a1(2);
ae1_2 = a1(3);
ae1_3 = a1(4);

Fe1 = ((I1^2+be1*abs(I1))*sign(I1))./(ae1_0.*z1_0 + ae1_1.*z1_1 + ae1_2.*z1_2 + ae1_3.*z1_3);

N1 = length(Fe_m1A);
Fe_m1Am = sum(Fe_m1A)/N1;
SSres1 = sum((Fe_m1A-Fe1).^2);
SST1 = sum((Fe_m1A-Fe_m1Am).^2);
RMS1 = sqrt(sum((Fe1-Fe_m1A).^2)/N1);
R1 = 1 - SSres1/SST1;
R1_2 = sum((Fe1-Fe_m1Am).^2)/sum((Fe_m1A-Fe_m1Am).^2);

if figures(1)
    figure()
    subplot(2,1,1)
    hold on
    plot(z_m1A,Fe1)
    plot(z_m1A,Fe_m1A)
    legend('Simulation selon les valeurs calculees avec -1A','Simulation selon les valeurs mesurees avec -1A')
    title('Comparaison entre valeurs calculees et mesurees pour -1A')
    xlabel('Distance du capteur (m)')
    ylabel('Fe (N)')
    hold off
    subplot(2,1,2)
    plot(z_m1A,Fe1-Fe_m1A)
    ErreurText = sprintf('Coefficient de determination R2 : %.4f\nValeur RMS : %.4f\t', R1,RMS1);
    legend(ErreurText)
    xlabel('Distance du capteur (m)')
    ylabel('Fe (N)')
end

if displays(1)
    disp('Qualite de l"approximation par les moindres carres de -1A :')
    disp('Valeur moyennes des mesures :')
    disp(Fe_m1Am)
    disp('Somme des residues au carre :')
    disp(SSres1)
    disp('Somme des erreurs totales au carre :')
    disp(SST1)
    disp('Coefficient de determination R2 :')
    disp(R1)
    disp('Valeur RMS :')
    disp(RMS1)
end


%% mesures avec -2A

load('Fe_attraction.mat')

I2 = -2;
be1 = 13.029359254409743;

z2_1 = z_m2A;
z2_0 = z2_1.^0;
z2_2 = z2_1.^2;
z2_3 = z2_1.^3;

Y2 = ((I2^2+be1*abs(I2))*sign(I2))./Fe_m2A;

X2 = [z2_0 z2_1 z2_2 z2_3];

a2 = pinv(X2)*Y2;
ae2_0 = a2(1);
ae2_1 = a2(2);
ae2_2 = a2(3);
ae2_3 = a2(4);

Fe2 = ((I2^2+be1*abs(I2))*sign(I2))./(ae2_0.*z2_0 + ae2_1.*z2_1 + ae2_2.*z2_2 + ae2_3.*z2_3);

N2 = length(Fe_m2A);
Fe_m2Am = sum(Fe_m2A)/N2;
SSres2 = sum((Fe_m2A-Fe2).^2);
SST2 = sum((Fe_m2A-Fe_m2Am).^2);
RMS2 = sqrt(sum((Fe2-Fe_m2A).^2)/N2);
R2 = 1 - SSres2/SST2;
R2_2 = sum((Fe2-Fe_m2Am).^2)/sum((Fe_m2A-Fe_m2Am).^2);

if figures(2)
    figure()
    subplot(2,1,1)
    hold on
    plot(z_m2A,Fe2)
    plot(z_m2A,Fe_m2A)
    legend('Simulation selon les valeurs calculees avec -2A','Simulation selon les valeurs mesurees avec -2A')
    title('Comparaison entre valeurs calculees et mesurees pour -2A')
    xlabel('Distance du capteur (m)')
    ylabel('Fe (N)')
    hold off
    subplot(2,1,2)
    plot(z_m2A,Fe2-Fe_m2A)
    ErreurText = sprintf('Coefficient de determination R2 : %.4f\nValeur RMS : %.4f\t', R2,RMS2);
    legend(ErreurText)
    xlabel('Distance du capteur (m)')
    ylabel('Fe (N)')
end

if displays(2)
    disp('Qualite de l"approximation par les moindres carres de -2A :')
    disp('Valeur moyennes des mesures :')
    disp(Fe_m2Am)
    disp('Somme des residues au carre :')
    disp(SSres2)
    disp('Somme des erreurs totales au carre :')
    disp(SST2)
    disp('Coefficient de determination R2 :')
    disp(R2)
    disp('Valeur RMS :')
    disp(RMS2)
end

%% Coefficients moyens

aMean = (a1+a2)./2;

aeMean_0 = aMean(1);
aeMean_1 = aMean(2);
aeMean_2 = aMean(3);
aeMean_3 = aMean(4);

Fe1Mean = ((I1^2+be1*abs(I1))*sign(I1))./(aeMean_0.*z1_0 + aeMean_1.*z1_1 + aeMean_2.*z1_2 + aeMean_3.*z1_3);
Fe2Mean = ((I2^2+be1*abs(I2))*sign(I2))./(aeMean_0.*z2_0 + aeMean_1.*z2_1 + aeMean_2.*z2_2 + aeMean_3.*z2_3);

SSres1 = sum((Fe_m1A-Fe1Mean).^2);
SST1 = sum((Fe_m1A-Fe_m1Am).^2);
RMS1 = sqrt(sum((Fe1Mean-Fe_m1A).^2)/N1);
R1 = 1 - SSres1/SST1;

SSres2 = sum((Fe_m2A-Fe2Mean).^2);
SST2 = sum((Fe_m2A-Fe_m2Am).^2);
RMS2 = sqrt(sum((Fe2Mean-Fe_m2A).^2)/N2);
R2 = 1 - SSres2/SST2;

if figures(3)
    figure()
    subplot(2,1,1)
    hold on
    plot(z_m1A,Fe1)
    plot(z_m1A,Fe1Mean)
    legend('Simulation selon les valeurs calculees avec coefficients moyens','Simulation selon les valeurs mesurees avec -1A')
    title('Comparaison entre valeurs calculees et mesurees pour -1A')
    xlabel('Distance du capteur (m)')
    ylabel('Fe (N)')
    hold off
    subplot(2,1,2)
    plot(z_m1A,Fe1-Fe1Mean)
    ErreurText = sprintf('Coefficient de determination R2 : %.4f\nValeur RMS : %.4f\t', R1,RMS1);
    legend(ErreurText)
    xlabel('Distance du capteur (m)')
    ylabel('Fe (N)')
end

if figures(4)
    figure()
    subplot(2,1,1)
    hold on
    plot(z_m2A,Fe2)
    plot(z_m2A,Fe2Mean)
    legend('Simulation selon les valeurs calculees avec coefficients moyens','Simulation selon les valeurs mesurees avec -2A')
    title('Comparaison entre valeurs calculees et mesurees pour -2A')
    xlabel('Distance du capteur (m)')
    ylabel('Fe (N)')
    hold off
    subplot(2,1,2)
    plot(z_m2A,Fe2-Fe2Mean)
    ErreurText = sprintf('Coefficient de determination R2 : %.4f\nValeur RMS : %.4f\t', R2,RMS2);
    legend(ErreurText)
    xlabel('Distance du capteur (m)')
    ylabel('Fe (N)')
end

if displays(3)
    disp('Les coefficients choisis correspondent a la moyenne des coefficients')
    disp('calcules avec -1A et -2A : ')
    disp('ae0 : '),
    disp(aMean(1))
    disp('ae1 : '),
    disp(aMean(2))
    disp('ae2 : '),
    disp(aMean(3))
    disp('ae3 : '),
    disp(aMean(4))
end

%% mesures avec Fs

load('Fs.mat')

z_pos = z_pos(1:150);       %Les valeurs du debut sont plus importante que celles de la fin
Fs = Fs(1:150);             %pour la determination des coefficients (la fin tend vers zero)

z3_1 = z_pos;
z3_0 = z3_1.^0;
z3_2 = z3_1.^2;
z3_3 = z3_1.^3;

Y3 = -1./Fs;

X3 = [z3_0 z3_1 z3_2 z3_3];

a3 = pinv(X3)*Y3;
as_0 = a3(1);
as_1 = a3(2);
as_2 = a3(3);
as_3 = a3(4);

load('Fs.mat')
z3_1 = z_pos;
z3_0 = z3_1.^0;
z3_2 = z3_1.^2;
z3_3 = z3_1.^3;

Fs_sim = -1./(as_0.*z3_0 + as_1.*z3_1 + as_2.*z3_2 + as_3.*z3_3);

NFs = length(Fs);
FsMean = sum(Fs)/NFs;
SSresFs = sum((Fs-Fs_sim).^2);
SSTFs = sum((Fs-FsMean).^2);
RMSFs = sqrt(sum((Fs_sim-Fs).^2)/NFs);
RFs = 1 - SSresFs/SSTFs;




if figures(5)
    figure()
    subplot(3,1,1)
    hold on
    plot(z_pos,Fs_sim)
    plot(z_pos,Fs)
    legend('Simulation selon les valeurs calculees','Simulation selon les valeurs mesurees2')
    title('Comparaison entre valeurs calculees et mesurees')
    xlabel('Distance du capteur (m)')
    ylabel('Fs (N)')
    hold off
    subplot(3,1,2)
    plot(z_pos,Fs_sim-Fs)
    ErreurText = sprintf('Coefficient de determination R2 : %.4f\nValeur RMS : %.4f\t', RFs,RMSFs);
    legend(ErreurText)
    xlabel('Distance du capteur (m)')
    ylabel('Fs (N)')
   
end

if displays(4)
    disp('Qualite de l"approximation par les moindres carres de Fs :')
    disp('Valeur moyennes des mesures :')
    disp(FsMean)
    disp('Somme des residues au carre :')
    disp(SSresFs)
    disp('Somme des erreurs totales au carre :')
    disp(SSTFs)
    disp('Coefficient de determination R2 :')
    disp(RFs)
    disp('Valeur RMS :')
    disp(RMSFs)
end

%% Choix des coefficients finaux

if displays(5)
    disp('Les coefficients choisis sont :')
    disp('as0 : '),
    disp(a3(1))
    disp('as1 : '),
    disp(a3(2))
    disp('as2 : '),
    disp(a3(3))
    disp('as3 : '),
    disp(a3(4))
end

%% savegarde dans fichier .mat

    ae0 = a2(1);
    ae1 = a2(2);
    ae2 = a2(3);
    ae3 = a2(4);
    
    as0 = a3(1);
    as1 = a3(2);
    as2 = a3(3);
    as3 = a3(4);
    
save('CoefficientsActionneurs.mat','ae0','ae1','ae2','ae3','as0','as1','as2','as3','be1')
%% comparaison lineaire et non lineaire



Isim = -0.491728; %Anciennement -0.491728, maintenant Ie

zsim = 0:0.0001:0.03;



Fenonlineairesim = ((Isim^2+be1*abs(Isim))*sign(Isim))./(ae0 + ae1.*zsim + ae2.*zsim.^2 + ae3.*zsim.^3);

Fsnonlineairesim = -1./(as_0 + as_1.*zsim + as_2.*zsim.^2 + as_3.*zsim.^3);

Fnonlineairesim = Fenonlineairesim+Fsnonlineairesim;

%Ajouter par Samuel pour comparer l'actionneur lin�aire au non lin�aire

load('CoefficientsActionneurs.mat')
load('EquationLinearisation.mat')
syms AE0 AE1 AE2 AE3 BE1
syms AS0 AS1 AS2 AS3
syms F I z Z IE ZE
ze = 0.0152;
Fe = -1.41591;
Ie = -0.491728;

% Part1 = (2*Ie+be1)/(ae0+ae1*ze+ae2*ze.^2+ae3*ze.^3); 
% Part2 = ((3*as3*ze.^2+2*as2*ze+as1)/(as0+as1*ze+as2*ze.^2+as3*ze.^3).^2)-((Ie.^2-be1*Ie)*(3*ae3*ze.^2+2*ae2*ze+ae1)/((ae0+ae1*ze+ae2*ze.^2+ae3*ze.^3).^2));

%Fs_Lin = (z_pos-ze)*Part2

% F = (Isim-Ie)*Part1 + (zsim-ze)*Part2 + Fe; %Il y a une erreur dans
% l'�quation mais le version qui vient de EquationDynamique est ok
Flin = EquationDynamique;
Flin = subs(Flin, AE3, ae3);
Flin = subs(Flin, AE2, ae2);
Flin = subs(Flin, AE1, ae1);
Flin = subs(Flin, AE0, ae0);

Flin = subs(Flin, AS3, as3);
Flin = subs(Flin, AS2, as2);
Flin = subs(Flin, AS1, as1);
Flin = subs(Flin, AS0, as0);
Flin = subs(Flin, BE1, be1);

Flin = subs(Flin, Z, zsim);
Flin = subs(Flin, I, Isim);
Flin = subs(Flin, IE, Ie);
Flin = subs(Flin, ZE, ze)

Flin = Flin + Fe

if figures(6)

    figure()

    hold on

    plot(zsim,Fnonlineairesim)

    plot(zsim, Flin)
    
    xlabel('Position en m�tre')
    ylabel('Force en N')
    title('Simulation vs lin�aire')
    legend('Simulation non-lin�aire','Simulation lin�aire')
    

end


if figures(7)

    figure()

    hold on
    plot(zsim,Fnonlineairesim-Flin)

    title('Erreur entre simulation et version lin�aire')      %lineaire
    xlabel('Position en m�tre')
    ylabel('Force en N')

end