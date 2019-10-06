clc
clear all

%% Nomenclature des variables
% 
% masseS      %masse de la sphere
% masseP      %masse de la plaque
% inertiePx   %inertie de la plaque autour de l'axe x
% inertiePy   %inertie de la plaque autour de l'axe y
% XK, YK, ZK  %position inertielle des elements fixes K (K = A, B, C, D, E, F)
% Px, Py, Pz  %position de la sphere dans le repere inertiel
% Vx, Vy, Vz  %vitesse de la sphere dans le repere inertiel
% Ax, Ay      %angle de rotation de la plaque autour de l'axe Ix et Iy
% Wx, Wy      %vitesse angulaire de la plaque autour de l'axe Ix et Iy
% FA, FB, FC  %forces appliquee par les actionneurs sur la plaque (positif vers le bas)
% Ma, MB, MC  %couples appliquee par les actionneurs sur la plaque
% VA, VB, VC  %tension electrique appliquee aux actionneurs
% IA, IB, IC  %courant electrique dans les actionneurs
%
%_mes         %refere a des variables mesurees
%_des         %refere aux variables desirees ou commandees
%_ini         %refere aux variables initiales
%_fin         %refere aux variables finales
%_eq          %refere aux variables a l'equilibre
%
%% Declaration des variables parametriques

syms masseS masseP inertiePx inertiePy 
syms XA YA ZA 
syms XB YB ZB 
syms XC YC ZC 
syms XD YD ZD 
syms XE YE ZE 
syms XF YF ZF 
syms Px Py Pz  
syms Vx Vy Vz 
syms Ax Ay Wx Wy    
syms FA FB FC
syms MA MB MC
syms VA VB VC
syms IA IB IC 

%%






