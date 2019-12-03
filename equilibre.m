%**************************************************************************
% 
% Fichier: equilibre.m
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
% R�sum�: Ce fichier contient les �quations du syst�me � l'�quilibre.
% 
%**************************************************************************

disp('Calcul des conditions d''�quilibre...')

load('CoefficientsActionneurs.mat')
syms VAeq VBeq VCeq IAeq IBeq ICeq FAeq FBeq FCeq


Pyeq = ySeq;
Pxeq = xSeq;

% Lois de Newton
d2zeq =  FAeq/mtot + FBeq/mtot + FCeq/mtot + g;
d2Axeq = (FAeq*YA + FBeq*YB + FCeq*YC + g*mS*Pyeq)/Jx;
d2Ayeq = (-FAeq*XA-FBeq*XB-FCeq*XC-g*mS*Pxeq)/Jy;


% Calcul des trois positions en z selon les angles
ZAeq = Pzeq - XA*deg2rad(Ayeq) + YA*deg2rad(Axeq) ;
ZBeq = Pzeq - XB*deg2rad(Ayeq) + YB*deg2rad(Axeq) ;
ZCeq = Pzeq - XC*deg2rad(Ayeq) + YC*deg2rad(Axeq) ;

% Calcul des forces � l'�quilibre
[FAeq FBeq FCeq] = solve([d2zeq d2Axeq d2Ayeq], [FAeq FBeq FCeq]);

eqFA = sign(IAeq)*(IAeq^2 + be1*abs(IAeq))/(ae0 + ZAeq*ae1 + ZAeq^2*ae2 + ZAeq^3*ae3)  == FAeq + 1/(as0 + ZAeq*as1 + ZAeq^2*as2 + ZAeq^3*as3);
eqFB = sign(IBeq)*(IBeq^2 + be1*abs(IBeq))/(ae0 + ZBeq*ae1 + ZBeq^2*ae2 + ZBeq^3*ae3)  == FBeq + 1/(as0 + ZBeq*as1 + ZBeq^2*as2 + ZBeq^3*as3);
eqFC = sign(IBeq)*(ICeq^2 + be1*abs(ICeq))/(ae0 + ZCeq*ae1 + ZCeq^2*ae2 + ZCeq^3*ae3) == FCeq + 1/(as0 + ZCeq*as1 + ZCeq^2*as2 + ZCeq^3*as3); 

% Courants � l'�quilibre

[IAeq IBeq ICeq] = solve([eqFA eqFB eqFC], [IAeq IBeq ICeq]);

% Tensions � l'�quilibre

VAeq = double(IAeq*RA);
VBeq = double(IBeq*RB);
VCeq = double(ICeq*RC);