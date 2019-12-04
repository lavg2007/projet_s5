%**************************************************************************
% 
% Fichier: CompensateurSphere.m
% Date: 2019-12-03
% Universit� de Sherbrooke - G�nie �lectrique
% 
% �quipe P4:
%           Brittany Latour - latb2901 
%           Samuel Mathieu - mats2510 
%           Jacob Fortin - forj1928 
%           Gabriel Lavoie - lavg2007 
%           Olivier Chr�tien-Rioux - chro2901 
%           Sarah Clauzade - clas2902 
%           Thierry Letalnet - lett2101 
%
%  R�sum�: Ce fichier contient les sp�cifications et calculs n�c�ssaires �
%  la compensation du syst�me avec la sph�re pr�sente.
% 
%**************************************************************************

%% calcul des compensateurs (sphere)

% sp�cifications 
ts_s = 2; % entre 2 et 4
zeta_s = 0.9;
wn_s = -log(0.02)/(zeta_s*ts_s);

% calcul des param�tres
num_y = 7.007;
Kv_y = 2*zeta_s*wn_s/num_y;
Kp_y = wn_s^2/num_y;

num_x = -7.007;
Kv_x = 2*zeta_s*wn_s/num_x;
Kp_x = wn_s^2/num_x;