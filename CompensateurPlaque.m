%**************************************************************************
% 
% Fichier: CompensateurPlaque.m
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
%  Résumé: Ce fichier, à l'aide des spécifications du client, calcul les
%  fonctions de transfert du compensateur en phi et en Z.
% 
%**************************************************************************

warning('off','all')
%% loading functions and tfs

addpath('Functions')
load('Plaque.mat')
load('PIz.mat')

%% Consideration importantes

%frequence angulaire naturelle des poles et zeros < 1000 rad/s
%Avec testdiscret.p (prend la tf du compensateur) :
    %lieu de Bode ne peut diverger que de 400 rad/s de la frequence de
    %Nyquist (1508 rad/s)
    %Tous les poles discretises doivent avoir un module < 1
    %PM = 25
    %GM = 10
%PAS DE COMPENSATEUR DERIVE

%% Security specs angles

PM_angle = 25;
GM_angle = 10;
angleMax = 5;

MP_angle = 5.0;
ts_angle = 0.030;
tp_angle = 0.025;
tr_angle = 0.020;
erp_echelon_angle = 0;

phi_angle = atand(-pi/log(MP_angle/100));
zeta_angle = cosd(phi_angle);
Wn1_angle = 4/(ts_angle*zeta_angle);
Wn2_angle = (1 + 1.1*zeta_angle + 1.4*zeta_angle^2)/tr_angle;
Wn3_angle = (pi/(tp_angle*sqrt(1 - zeta_angle^2)));

Wn_angle = max([Wn1_angle,Wn2_angle,Wn3_angle]);
clear Wn1_angle Wn2_angle Wn3_angle
Wa_angle = Wn_angle*sqrt(1-zeta_angle^2);
s_angle = [-zeta_angle*Wn_angle + Wa_angle*1i; -zeta_angle*Wn_angle - Wa_angle*1i];

%% compensateur en phi

% AVANCE DE PHASE #1

tf_compensateur_phi1 = DoubleAvanceDePhase( tf_phi,phi_angle,Wn_angle,zeta_angle,Wa_angle,s_angle,6.2)*1.12;     %marge  = 10  %marge = 15 gain = 0.7
tf_phi_compense = tf_phi*tf_compensateur_phi1;

% PI (CHANGEMENT DE CLASSE POUR ERP)

tf_compensateur_phi2 = ProportionnelIntegralV1( tf_phi_compense,s_angle,5);    %marge = 5  gain = 2
tf_phi_compense = tf_phi_compense*tf_compensateur_phi2;

tf_compensateur_phi = tf_compensateur_phi1*tf_compensateur_phi2*1.7;
tf_phi_compense = tf_phi*tf_compensateur_phi;

figure()
hold on
plot(s_angle,'p')
rlocus(tf_phi)

figure()
hold on
plot(s_angle,'p')
rlocus(tf_phi_compense)

figure()
t = (0:0.001:0.5)';
step(feedback(tf_phi_compense,1),t)

figure()
nyquist(tf_phi_compense)
grid on

stepInfoFTBF = stepinfo(feedback(tf_phi_compense,1));
marginInfoFTBO = allmargin(tf_phi_compense);
GMFTBO = 20*log10(marginInfoFTBO.GainMargin);
PMFTBO = (marginInfoFTBO.PhaseMargin);
BWangle = bandwidth(feedback(tf_phi_compense,1))

disp(['Overshoot    |   5.0   |    ' num2str(stepInfoFTBF.Overshoot,4)])   
disp(['SettlingTime |  0.030  |    ' num2str(stepInfoFTBF.SettlingTime,4)])  
disp(['PeakTime     |  0.025  |    ' num2str(stepInfoFTBF.PeakTime,4)])  
disp(['RiseTime     |  0.020  |    ' num2str(stepInfoFTBF.RiseTime,4)]) 
disp(['GainMargin   |   10    |    ' num2str(GMFTBO,2)])
disp(['PhaseMargin  |   25    |    ' num2str(PMFTBO,2)])
disp(['Bandwidth    |         |    ' num2str(BWangle,4)])
disp([' ------ ']) 

figure()
margin(tf_phi_compense)

% testdiscret(tf_compensateur_phi)

[num_compensateur_angle,den_compensateur_angle] = tfdata(tf_compensateur_phi,'v');

%% Security specs hauteur

PM_hauteur = 25;
Wg_hauteur = 185;
erp_echelon_hauteur = -0.0004; %pour consigne 0.01 (cas1) ou 0 pour echelon (cas2)

zeta_z = 0.5*sqrt(tand(PM_hauteur)*sind(PM_hauteur));
BW_z = Wg_hauteur*sqrt((1-2*zeta_z^2)+sqrt(4*zeta_z^4 - 4*zeta_z^2 +2))/(sqrt(sqrt(1-4*zeta_z^4)-2*zeta_z^2));

%% compensateur en Z

% AVANCE DE PHASE #1

tf_compensateur_z1 = AvancePhaseBode1( tf_z, PM_hauteur, BW_z, 6 );
tf_z_compense = tf_z*tf_compensateur_z1;

tf_compensateur_z2 = AvancePhaseBode1( tf_z_compense, PM_hauteur, BW_z, 7 );
tf_z_compense = tf_z_compense*tf_compensateur_z2;

if PI_z
    tf_compensateur_z3 = ProportionnelIntegralBode( tf_z_compense,Wg_hauteur, 10 );
    tf_z_compense = tf_z_compense*tf_compensateur_z3;

    else 
    tf_compensateur_z3 = RetardPhaseBode1( tf_z_compense, erp_echelon_hauteur, Wg_hauteur, 10 );      
    tf_z_compense = tf_z_compense*tf_compensateur_z3;
end

tf_compensateur_z = tf_compensateur_z1*tf_compensateur_z2*tf_compensateur_z3;
tf_z_compense = tf_compensateur_z*tf_z;

figure()
margin(tf_z)

figure()
margin(tf_z_compense)

figure()
opt = stepDataOptions('StepAmplitude',0.01);
hold on
step(feedback(tf_z_compense,1),0.5,opt)  % Step response with step amplitude of 0.01;
% yline(0.01+erp_echelon_hauteur,'linewidth',1);
% yline(0.01-erp_echelon_hauteur,'linewidth',1);

figure()
nyquist(tf_z_compense)
grid on

marginInfoFTBO = allmargin(tf_z_compense);
GMFTBO = 20*log10(marginInfoFTBO.GainMargin);
PMFTBO = (marginInfoFTBO.PhaseMargin);
PMFFTBO = (marginInfoFTBO.PMFrequency);
BWz = bandwidth(feedback(tf_z_compense,1))

disp(['GainMargin   |   10    |    ' num2str(GMFTBO,2)])
disp(['PhaseMargin  |   25    |    ' num2str(PMFTBO,2)])
disp(['PMFrequency  |   185   |    ' num2str(PMFFTBO,3)])
disp(['Bandwidth    |         |    ' num2str(BWz,4)])
disp([' ------ ']) 

% testdiscret(tf_compensateur_z)

[num_compensateur_z,den_compensateur_z] = tfdata(tf_compensateur_z,'v');

save('Compensateur.mat','num_compensateur_z','den_compensateur_z','num_compensateur_angle','den_compensateur_angle')