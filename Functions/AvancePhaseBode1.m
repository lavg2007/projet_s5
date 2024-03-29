%**************************************************************************
% 
% Fichier: AvancePhaseBode1.m
% Date: 2019-12-02
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
% R�sum�: Calcul d'un compensateur avance de phase a partir de la marge de 
% phase (PM) et de la bande passante (BW).
% 
% Entr�s:  FTBO -> Une fonction de transfert en boucle ouverte
%          PM_s -> Marge de phase d�sir�
%          BW_s -> Bande passante d�sir�
% 
% Sortie:  Ga -> Fonction de transfert du compensateur � avance de phase
% fait � partir de sp�cification en PM et BW.
% 
%**************************************************************************

function [ Ga ] = AvancePhaseBode1( FTBO, PM_s, BW_s, att )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

zeta_s = 0.5*sqrt(tand(PM_s)*sind(PM_s));
wn_s = BW_s/sqrt((1-2*zeta_s^2)+(sqrt(4*zeta_s^4-4*zeta_s^2+2)));
wg_s = 2*zeta_s*wn_s/tand(PM_s);

K_s = 1/(norm(polyval(FTBO.Numerator{:},1i*wg_s)/polyval(FTBO.Denominator{:},1i*wg_s)));

[~,PM_Ks,~,~] = margin(FTBO*K_s);

if PM_Ks >= PM_s
    disp('No need for a FT, just a gain')
    Ga = K_s;
    return
end
    
PM_s;
deltaphi = PM_s - PM_Ks
deltaphi = PM_s - PM_Ks+att;

a = (1-sind(deltaphi))/(1+sind(deltaphi));

T = 1/(wg_s*sqrt(a));

z = -1/T;
p = -1/(a*T);
Ka = K_s/sqrt(a);

Ga = tf([1 -z],[1 -p]);
Ga = Ga * Ka;
end

