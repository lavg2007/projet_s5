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
%  démarrer les simulations avec ou sans sphère et tout les fichiers
%  éssentiels sont reliés ici ainsi que les graphiques de Nyquist.
% 
%**************************************************************************

close all
clear all
clc

% Position à l'équilibre de la sphère (pour tests statiques)
sig = 0;         % Présence (1) ou non (0) de la sphère
xSeq = 0.0;      % Position x de la sphère à l'équilibre en metres
ySeq = 0.0;      % Position y de la sphère à l'équilibre en metres
PI_z = 1;        % Erreur en rp pour le compensateur en z = 0 pour PI_z = 1
save('PIz.mat','PI_z')

%Point d'opération choisi pour la plaque
Axeq = 0;               %en degres
Ayeq = 0;               %en degres
Pzeq = 0.015;    



% % Position à l'équilibre de la sphère (pour tests statiques)
% sig = 1;         % Présence (1) ou non (0) de la sphère
% xSeq = 0.003;      % Position x de la sphère à l'équilibre en metres
% ySeq = 0.050;      % Position y de la sphère à l'équilibre en metres
% PI_z = 1;          % Erreur en rp pour le compensateur en z = 0 pour PI_z = 1
% save('PIz.mat','PI_z')
% 
% %Point d'opération choisi pour la plaque
% Axeq = 1;               %en degres
% Ayeq = 0.5;               %en degres
% Pzeq = 0.011;            %en metres

%Exemple de trajectoire
t_des     = [0:1:8]'*5;
x_des     = [t_des, [0 0 0 0 0 0 0 0 0]'*0.05];
y_des     = [t_des, [0 0 0 0 0 0 0 0 0]'*0.05];
z_des     = [t_des, [1 1 1 1 1 1 1 1 1]'*.015];
tfin = 50;

x_d     = [-1:0.2:1]'*0.05;
y_d     = [0 0.2 0.5 0 -1  0 1 0 0 0.2 -1]'*0.05;


%initialisation
disp('initialisation...')
bancEssaiConstantes;
load('CoefficientsActionneurs.mat')

mS = 0;
mS = 40/1000;

Ts = 2;
[Pi,Ltr, E, Vr, Traj, tt, tab] = trajectoire(x_d,y_d,0.01,Ts);
t_des = [0:Ts:tt]';
x_des     = [t_des, Traj(:,1)];
y_des     = [t_des, Traj(:,2)];
z_des     = [t_des, ones(size(t_des))*0.015];
tfin = tt+Ts;

%%

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

figure()
subplot(3,1,1)
title('Système non-linéaire, positions')
hold on
plot(tsim, x_des_out1)
plot(tsim, ynonlineaire2(:,7))
xlabel('Temps(s)')
ylabel('x (m)')
legend('Désirée', 'Simulée')

subplot(3,1,2)
hold on
plot(tsim, y_des_out1)
plot(tsim, ynonlineaire2(:,8))
xlabel('Temps(s)')
ylabel('y (m)')
legend('Désirée', 'Simulée')

subplot(3,1,3)
hold on
plot(tsim, z_des_out1)
plot(tsim, ynonlineaire2(:,3))
xlabel('Temps(s)')
ylabel('z (m)')
legend('Désirée', 'Simulée')

figure
subplot(2,1,1)
title('Système non-linéaire, angles')
hold on
plot(tsim, Ax_des1)
plot(tsim, ynonlineaire2(:,1))
xlabel('Temps(s)')
ylabel('\phi (rad)')
legend('Désiré', 'Simulé')

subplot(2,1,2)
hold on
plot(tsim, Ay_des1)
plot(tsim, ynonlineaire2(:,2))

figure()
hold on
plot(DetectionViolation)
plot(DetectionViolation1)
plot(DetectionViolation2)
%%
figure()

subplot(3,1,1)
hold on
plot(tsim, ynonlineaire2(:,17))
plot(tsim, ynonlineaire(:,17))
plot(tsim, ylineaire1(:,1))
plot(tsim, ylineaire(:,1))

subplot(3,1,2)
hold on
plot(tsim, ynonlineaire2(:,18))
plot(tsim, ynonlineaire(:,18))
plot(tsim, ylineaire1(:,2))
plot(tsim, ylineaire(:,2))

subplot(3,1,3)
hold on
plot(tsim, ynonlineaire2(:,19))
plot(tsim, ynonlineaire(:,19))
plot(tsim, ylineaire1(:,3))
plot(tsim, ylineaire(:,3))

xlabel('Temps(s)')
ylabel('\theta (rad)')
legend('Désiré', 'Simulé')

%%
figure()
subplot(2,1,1)
title('Système linéaire')
hold on
plot(tsim, x_des_out1)
plot(tsim, ylineaire(:,4))
xlabel('Temps(s)')
ylabel('x (m)')
legend('Désirée', 'Simulée')

subplot(2,1,2)
hold on
plot(tsim, y_des_out1)
plot(tsim, ylineaire(:,5))
xlabel('Temps(s)')
ylabel('y (m)')
legend('Désirée', 'Simulée')

%% 
figure()
subplot(2,1,1)
title('Système linéaire')
hold on
plot(tsim, x_des_out1)
plot(tsim, ylineaire1(:,4))
xlabel('Temps(s)')
ylabel('x (m)')
legend('Désirée', 'Simulée')

subplot(2,1,2)
hold on
plot(tsim, y_des_out1)
plot(tsim, ylineaire1(:,5))
xlabel('Temps(s)')
ylabel('y (m)')
legend('Désirée', 'Simulée')
