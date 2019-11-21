close all
clear all
clc

%Modelisation

% Position à l'équilibre de la sphère (pour tests statiques)
sig = 1;         % Présence (1) ou non (0) de la sphère
xSeq = 0.000;      % Position x de la sphère à l'équilibre en metres
ySeq = 0.000;      % Position y de la sphère à l'équilibre en metres

%Point d'opération choisi pour la plaque
Axeq = 0;               %en degres
Ayeq = 0;               %en degres
Pzeq = .015;            %en metres

%Exemple de trajectoire
t_des     = [0:1:8]'*5;
x_des     = [t_des, [0 0 0.5 1  0 -1 0 1 0]'*0.05];
y_des     = [t_des, [0 0 0.5 0 -1  0 1 0 0]'*0.05];
z_des     = [t_des, [1 1 1 1  1  1 1 1 1]'*.015];
% t_des     = [0:1:8]'*5;
% x_des     = [t_des, xSeq*ones([9 1])];
% y_des     = [t_des, ySeq*ones([9 1])];
% z_des     = [t_des, [1 1 1 1  1  1 1 1 1]'*.015];
tfin = 50;

%initialisation
disp('initialisation...')
bancEssaiConstantes
load('CoefficientsActionneurs.mat')

%bancessai_ini  %faites tous vos calculs de modele ici
load('Linearisation.mat')
equilibre
A = eval(subs(A));
B = eval(subs(B));
C = eval(subs(C));
D = eval(subs(D));

SP = eval(subs(SP))

% matrices découplées
A_sphere_x =  [0 1; 0 0];
B_sphere_x = [0;SP(1,2)];
C_sphere_x = eye(2);
D_sphere_x = [0;0];

A_sphere_y = [0 1; 0 0];
B_sphere_y = [0; SP(2,1)];
C_sphere_y = eye(2);
D_sphere_y = [0;0];


A_plaque = [zeros(3) eye(3) zeros(3);
            eval(subs(PP)) zeros(3) eval(subs(PC))*inv(U);
            zeros(3) zeros(3) eval(subs(CC))];
B_plaque = [zeros(3);zeros(3);eval(subs(CV))];

A_phi = [A_plaque(1,1) A_plaque(1,4) A_plaque(1,7);
         A_plaque(4,1) A_plaque(4,4) A_plaque(4,7);
         A_plaque(7,1) A_plaque(7,4) A_plaque(7,7)];

A_theta = [A_plaque(2,2) A_plaque(2,5) A_plaque(2,8);
         A_plaque(5,2) A_plaque(5,5) A_plaque(5,8);
         A_plaque(8,2) A_plaque(8,5) A_plaque(8,8)];

A_z = [A_plaque(3,3) A_plaque(3,6) A_plaque(3,9);
         A_plaque(6,3) A_plaque(6,6) A_plaque(6,9);
         A_plaque(9,3) A_plaque(9,6) A_plaque(9,9)];

B_phi = [0;0;B_plaque(7,1)];
B_theta = [0;0;B_plaque(8,2)];
B_z = [0;0;B_plaque(9,3)];

C_dec = [1 0 0];
D_dec = [0];


tf_sphere_x = tf(ss(A_sphere_x, B_sphere_x, C_sphere_x, D_sphere_x));
tf_sphere_y = tf(ss(A_sphere_y, B_sphere_y, C_sphere_y, D_sphere_y));

tf_phi = tf(ss(A_phi, B_phi, C_dec, D_dec));
tf_theta = tf(ss(A_theta, B_theta, C_dec, D_dec));
tf_z = tf(ss(A_z, B_z, C_dec, D_dec));

%% calcul des compensateurs (sphere

% spécifications 
ts_s = 2 % entre 2 et 4
zeta_s = 0.9
wn_s = -log(0.02)/(zeta_s*ts_s)

% calcul des paramètres
num_y = 7.007;
Kv_y = 2*zeta_s*wn_s/num_y;
Kp_y = wn_s^2/num_y;

num_x = -7.007;
Kv_x = 2*zeta_s*wn_s/num_x;
Kp_x = wn_s^2/num_x;

%%
figure
pzmap(ss(A,B,C,D))
vp = eig(A)


%Calcul des compensateurs
%iniCTL_ver4    %Calculez vos compensateurs ici

%% simulation
% open_system('DYNctl_ver4_etud_obfusc')
% set_param('DYNctl_ver4_etud_obfusc','AlgebraicLoopSolver','LineSearch')
% sim('DYNctl_ver4_etud_obfusc')
disp('Simulation...')
open_system('SimulationV4')
set_param('SimulationV4','AlgebraicLoopSolver','TrustRegion')
sim('SimulationV4')

%% Plot test
% figure()
% subplot(2,1,1)
% % hold on
% % plot(tsim,ynonlineaire(:,1)-ynonlineaire2(:,1))
% % plot(tsim,ynonlineaire(:,2)-ynonlineaire2(:,2))
% % plot(tsim,ynonlineaire(:,3)-ynonlineaire2(:,3))
% % plot(tsim,ynonlineaire(:,4)-ynonlineaire2(:,4))
% % plot(tsim,ynonlineaire(:,5)-ynonlineaire2(:,5))
% % plot(tsim,ynonlineaire(:,6)-ynonlineaire2(:,6))
% % plot(tsim,ynonlineaire(:,7)-ynonlineaire2(:,7))
% % plot(tsim,ynonlineaire(:,8)-ynonlineaire2(:,8))
% % plot(tsim,ynonlineaire(:,9)-ynonlineaire2(:,9))
% % plot(tsim,ynonlineaire(:,10)-ynonlineaire2(:,10))
% % plot(tsim,ynonlineaire(:,11)-ynonlineaire2(:,11))
% % plot(tsim,ynonlineaire(:,12)-ynonlineaire2(:,12))
% % plot(tsim,ynonlineaire(:,13)-ynonlineaire2(:,13))
% % plot(tsim,ynonlineaire(:,14)-ynonlineaire2(:,14))
% % plot(tsim,ynonlineaire(:,15)-ynonlineaire2(:,15))
% % plot(tsim,ynonlineaire(:,16)-ynonlineaire2(:,16))
% % plot(tsim,ynonlineaire(:,17)-ynonlineaire2(:,17))
% % plot(tsim,ynonlineaire(:,18)-ynonlineaire2(:,18))
% % plot(tsim,ynonlineaire(:,19)-ynonlineaire2(:,19))
% % plot(tsim,ynonlineaire(:,20)-ynonlineaire2(:,20))
% % plot(tsim,ynonlineaire(:,21)-ynonlineaire2(:,21))
% % plot(tsim,ynonlineaire(:,22)-ynonlineaire2(:,22))
% plot(tsim,ynonlineaire(:,23)-ynonlineaire2(:,23))
% % plot(tsim,ynonlineaire(:,24)-ynonlineaire2(:,24))
% % plot(tsim,ynonlineaire(:,25)-ynonlineaire2(:,25))
% % axis([0 50 -2 2])
% subplot(2,1,2)
% hold on
% plot(tsim,ynonlineaire(:,23))
% plot(tsim,ynonlineaire(:,24))
% plot(tsim,ynonlineaire(:,25))
% plot(tsim,ynonlineaire2(:,23),'--')

figure()
subplot(3,1,1)
hold on
plot(tsim, x_des_out1)
plot(tsim, ynonlineaire2(:,7))

subplot(3,1,2)
hold on
plot(tsim, y_des_out1)
plot(tsim, ynonlineaire2(:,8))

subplot(3,1,3)
hold on
plot(tsim, z_des_out1)
plot(tsim, ynonlineaire2(:,3))


% figure()
% subplot(2,1,1)
% hold on
% plot(tsim, x_des_out1)
% plot(tsim, ylineaire(:,4))
% 
% subplot(2,1,2)
% hold on
% plot(tsim, y_des_out1)
% plot(tsim, ylineaire(:,5))
% 
% figure()
% subplot(3,1,1)
% plot(tsim, ylineaire1(:,1))
% 
% subplot(3,1,2)
% plot(tsim, ylineaire1(:,2))
% 
% subplot(3,1,3)
% plot(tsim, ylineaire1(:,3))
% 
% figure()
% subplot(4,1,1)
% hold on
% plot(tsim, x_des_out1)
% plot(tsim, ylineaire1(:,4))
% 
% subplot(4,1,2)
% hold on
% plot(tsim, y_des_out1)
% plot(tsim, ylineaire1(:,5))
% 
% subplot(4,1,3)
% plot(tsim, ylineaire1(:,6))
% 
% subplot(4,1,4)
% plot(tsim, ylineaire1(:,7))
% 
% 

% %affichage
%trajectoires