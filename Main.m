close all
clear all
clc

% Position à l'équilibre de la sphère (pour tests statiques)
sig = 1;         % Présence (1) ou non (0) de la sphère
xSeq = 0.000;      % Position x de la sphère à l'équilibre en metres
ySeq = 0.000;      % Position y de la sphère à l'équilibre en metres
PI_z = 0;          % Erreur en rp pour le compensateur en z = 0 pour PI_z = 1

%Point d'opération choisi pour la plaque
Axeq = 0;               %en degres
Ayeq = 0;               %en degres
Pzeq = .015;            %en metres

%Exemple de trajectoire
t_des     = [0:1:8]'*5;
x_des     = [t_des, [0 0 0.5 1  0 -1 0 1 0]'*0.05];
y_des     = [t_des, [0 0 0.5 0 -1  0 1 0 0]'*0.05];
z_des     = [t_des, [1 1 1 1  1  1 1 1 1]'*.015];
tfin = 50;

%initialisation
disp('initialisation...')
bancEssaiConstantes;
load('CoefficientsActionneurs.mat')

%bancessai_ini  %faites tous vos calculs de modele ici
CalculTFs;
CompensateurPlaque;
Uinv = inv(U);
CompensateurSphere;

%% simulation
disp('Simulation...')
open_system('SimulationV4')
set_param('SimulationV4','AlgebraicLoopSolver','LineSearch')
sim('SimulationV4')
%%
% figure()
% subplot(3,1,1)
% hold on
% plot(tsim, x_des_out1)
% plot(tsim, ynonlineaire2(:,7))

% subplot(3,1,2)
% hold on
% plot(tsim, y_des_out1)
% plot(tsim, ynonlineaire2(:,8))
% 
subplot(3,1,3)
hold on
plot(tsim, z_des_out1)
plot(tsim, ynonlineaire2(:,3))

subplot(3,1,1)
hold on
plot(tsim, Ax_des1)
plot(tsim, ynonlineaire2(:,1))

subplot(3,1,2)
hold on
plot(tsim, Ay_des1)
plot(tsim, ynonlineaire2(:,2))