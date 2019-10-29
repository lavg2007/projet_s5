close all
clear all
clc

% Position à l'équilibre de la sphère (pour tests statiques)
sig = 1.0;         % Présence (1) ou non (0) de la sphère
xSeq = 0.000;      % Position x de la sphère à l'équilibre en metres
ySeq = 0.000;      % Position y de la sphère à l'équilibre en metres

%Point d'opération choisi pour la plaque
Axeq = 0;               %en degres
Ayeq = 0;               %en degres
Pzeq = .015;            %en metres

%Exemple de trajectoire
t_des     = [0:1:8]'*5;
x_des     = [t_des, [0 0 0.5 1  0 -1 0 1 0]'*0.05];
y_des     = [t_des, [0 0 0 0 -1  0 1 0 0]'*0.05];
z_des     = [t_des, [1 1 1 1  1  1 1 1 1]'*.015];
tfin = 50;

%initialisation
bancEssaiConstantes
load('CoefficientsActionneurs.mat')

%bancessai_ini  %faites tous vos calculs de modele ici

%Calcul des compensateurs
%iniCTL_ver4    %Calculez vos compensateurs ici

%simulation
% open_system('DYNctl_ver4_etud_obfusc')
% set_param('DYNctl_ver4_etud_obfusc','AlgebraicLoopSolver','LineSearch')
% sim('DYNctl_ver4_etud_obfusc')
open_system('SimulationV2')
set_param('SimulationV2','AlgebraicLoopSolver','LineSearch')
sim('SimulationV2')

%% Plot test
figure()
subplot(2,1,1)
hold on
plot(tsim,ynonlineaire(:,1)-ynonlineaire2(:,1))
plot(tsim,ynonlineaire(:,2)-ynonlineaire2(:,2))
plot(tsim,ynonlineaire(:,3)-ynonlineaire2(:,3))
plot(tsim,ynonlineaire(:,4)-ynonlineaire2(:,4))
plot(tsim,ynonlineaire(:,5)-ynonlineaire2(:,5))
plot(tsim,ynonlineaire(:,6)-ynonlineaire2(:,6))
plot(tsim,ynonlineaire(:,7)-ynonlineaire2(:,7))
plot(tsim,ynonlineaire(:,8)-ynonlineaire2(:,8))
plot(tsim,ynonlineaire(:,9)-ynonlineaire2(:,9))
plot(tsim,ynonlineaire(:,10)-ynonlineaire2(:,10))
plot(tsim,ynonlineaire(:,11)-ynonlineaire2(:,11))
plot(tsim,ynonlineaire(:,12)-ynonlineaire2(:,12))
plot(tsim,ynonlineaire(:,13)-ynonlineaire2(:,13))
plot(tsim,ynonlineaire(:,14)-ynonlineaire2(:,14))
plot(tsim,ynonlineaire(:,15)-ynonlineaire2(:,15))
plot(tsim,ynonlineaire(:,16)-ynonlineaire2(:,16))
plot(tsim,ynonlineaire(:,17)-ynonlineaire2(:,17))
plot(tsim,ynonlineaire(:,18)-ynonlineaire2(:,18))
plot(tsim,ynonlineaire(:,19)-ynonlineaire2(:,19))
% plot(tsim,ynonlineaire(:,20)-ynonlineaire2(:,20))
% plot(tsim,ynonlineaire(:,21)-ynonlineaire2(:,21))
% plot(tsim,ynonlineaire(:,22)-ynonlineaire2(:,22))
plot(tsim,ynonlineaire(:,23)-ynonlineaire2(:,23))
plot(tsim,ynonlineaire(:,24)-ynonlineaire2(:,24))
plot(tsim,ynonlineaire(:,25)-ynonlineaire2(:,25))
subplot(2,1,2)
hold on
plot(tsim,ynonlineaire(:,3))
plot(tsim,ynonlineaire2(:,3),'--')


%affichage
%trajectoires