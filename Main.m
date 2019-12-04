%**************************************************************************
% 
% Fichier: Main.m
% Date: 2019-12-02
% Université de Sherbrooke - Génie électrique
% 
% Équipe P4:
%           Brittany Latour - latb2901 
%           Samuel Mathieu - mats2510   
%           Jacob Fortin - forj1928 
%           Gabriel Lavoie - lavg2007 
%           Olivier Chrétien-Rioux - chro2901 
%           Sarah Clauzade - clas2902 
%           Thierry Letalnet - lett2101 
%
%  Résumé: Ceci est le fichier principale du projet. Il est possible de
%  choisir avec ou sans la sphère pour les simulations et calculs. Il fait
%  référence aux calculs des fonctions de transfert, aux calculs des
%  compensateurs de la plaque et des spécifications de la compensation de la
%  sphère. La pluspart des graphiques de Nyquist, les diagrammes de Bodes
%  et les compensateurs apparaitrons avec un Run de ce fichier ainsi que
%  les simulations simulink.
% 
%**************************************************************************

close all
clear all
clc

% Position à l'équilibre de la sphère (pour tests statiques)
sig = 1;         % Présence (1) ou non (0) de la sphère
xSeq = 0.000;      % Position x de la sphère à l'équilibre en metres
ySeq = 0.000;      % Position y de la sphère à l'équilibre en metres
PI_z = 1;          % Erreur en rp pour le compensateur en z = 0 pour PI_z = 1
save('PIz.mat','PI_z')
load('trajectoire.mat')

%Point d'opération choisi pour la plaque
Axeq = 0;               %en degres
Ayeq = 0;               %en degres
Pzeq = .015;            %en metres

%Exemple de trajectoire
% t_des     = [0:1:8]'*5;
% x_des     = [t_des, [0 0 0.5 1  0 -1 0 1 0]'*0.05];
% y_des     = [t_des, [0 0 0.5 0 -1  0 1 0 0]'*0.05];
% z_des     = [t_des, [1 1 1 1  1  1 1 1 1]'*.015];
% tfin = 50;
%%

x_d     = [-1:0.2:1]'*0.05;
y_d     = [0 0.2 0.5 0 -1  0 1 0 0 0.2 -1]'*0.05;

x_d     = NBA(:,1);
y_d     = NBA(:,2);

Pxinitial = x_d(1);
Pyinitial = y_d(1);

%initialisation
disp('initialisation...')
bancEssaiConstantes;
load('CoefficientsActionneurs.mat')

% Ts = 2;
[Pi,Ltr, E, Vr, Traj, tt, tab] = trajectoire(x_d,y_d,vBA,Ts);
t_des = [0:Ts:abs(tt)]';
x_des     = [t_des, Traj(:,1)];
y_des     = [t_des, Traj(:,2)];
z_des     = [t_des, ones(size(t_des))*0.015];
tfin = abs(tt)+Ts;

%% Calcul des compensateurs

%bancessai_ini  %faites tous vos calculs de modele ici
CalculTFs;
CompensateurPlaque;
Uinv = inv(U);
CompensateurSphere;

%% simulations simulink

disp('Simulation...')
open_system('SimulationV4')
set_param('SimulationV4','AlgebraicLoopSolver','LineSearch')
sim('SimulationV4')

%% Graphiques

figure()
% subplot(3,1,1)
% hold on
% plot(tsim, x_des_out1)
% plot(tsim, ynonlineaire2(:,7))

% subplot(3,1,2)
% hold on
% plot(tsim, y_des_out1)
% plot(tsim, ynonlineaire2(:,8))

%% Figures

% Valeurs de x désirés vs valeurs obtenues
figure()
subplot(3,1,1)
title('Système non-linéaire, positions')
hold on
plot(tsim, x_des_out1)
plot(tsim, ynonlineaire2(:,7))
% [E, R2, RMS] = Erreur(tsim,x_des_out1,ynonlineaire2(:,7))

performanceX = sum(x_des_out1-ynonlineaire2(:,7))

xlabel('Temps(s)')
ylabel('x (m)')
legend('Désirée', 'Simulée')

% Valeurs de y désirés vs valeurs obtenues
subplot(3,1,2)
hold on
plot(tsim, y_des_out1)
plot(tsim, ynonlineaire2(:,8))
xlabel('Temps(s)')
ylabel('y (m)')
legend('Désirée', 'Simulée')
% [E, R2, RMS] = Erreur(tsim,y_des_out1,ynonlineaire2(:,8))
performanceY = sum(y_des_out1-ynonlineaire2(:,8))

% Valeurs de z désirés vs valeurs obtenues
subplot(3,1,3)
hold on
plot(tsim, z_des_out1)
plot(tsim, ynonlineaire2(:,3))
xlabel('Temps(s)')
ylabel('z (m)')
legend('Désirée', 'Simulée')

% Système linéaire
figure()
plot(DetectionViolation)

%%
% Valeurs de x et y désirés vs valeurs obtenues
figure()
hold on
plot(x_des_out1, y_des_out1)
plot(ynonlineaire2(:,7), ynonlineaire2(:,8))

% Valeurs de y désirés dans le système linéaire vs valeurs obtenues
subplot(2,1,2)
hold on
plot(tsim, y_des_out1)
plot(tsim, ylineaire(:,5))
xlabel('Temps(s)')
ylabel('y (m)')
legend('Désirée', 'Simulée')

%% 
% Valeurs de x désirés dans le système linéaire vs valeurs obtenues
figure()
subplot(2,1,1)
title('Système linéaire')
hold on
plot(tsim, x_des_out1)
plot(tsim, ylineaire1(:,4))
xlabel('Temps(s)')
ylabel('x (m)')
legend('Désirée', 'Simulée')

% Valeurs de y désirés dans le système linéaire vs valeurs obtenues
subplot(2,1,2)
hold on
plot(tsim, y_des_out1)
plot(tsim, ylineaire1(:,5))
xlabel('Temps(s)')
ylabel('y (m)')
legend('Désirée', 'Simulée')
