%**************************************************************************
% 
% Fichier: bancEssaiConstantes.m
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
% Résumé: Ici ce trouve les paramètres du banc d'éssai des capteurs et leur 
% matrice (aussi avec effet Hall).
% 
%**************************************************************************

% Constante de gravité
g   = 9.81;

z_range  = 22.2e-03; % m
zr_comb = [0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1]'*z_range;

% Distance 2D du centre des aimants de sustentation au centre de la plaque
rABC = 95.20e-03;     % m

% Course maximale en angle
A_range = (z_range/rABC)/(2*sqrt(2));

% Coordonnées des aimants
XA = +rABC;
YA =  0.0;
ZA =  0.0;
XB = -rABC*sind(30);
YB = +rABC*cosd(30);
ZB =  0.0;
XC = -rABC*sind(30);
YC = -rABC*cosd(30);
ZC =  0.0;

% Matrices des coordonnées
xvec_ABC = [XA, XB, XC]';
yvec_ABC = [YA, YB, YC]';

TABC = [yvec_ABC'; -xvec_ABC'; ones(1,3)];
TABC_inv = inv(TABC);

ptz_comb = TABC_inv' * zr_comb;
ptz_range = max(ptz_comb,[],2);

% Distance 2D du centre des aimants effet Hall au centre de la plaque
rDEF = 80.00e-03;     % m

% Coordonnées des capteurs à effet Hall
% Données mises à jour le 10 mai 2015
XD = +rDEF*sind(30);
YD = +rDEF*cosd(30);
ZD =  0.0;
XE = -rDEF;
YE =  0.0;
ZE =  0.0;
XF = +rDEF*sind(30);
YF = -rDEF*cosd(30);
ZF =  0.0;

% Matrices des coordonnées des capteurs à effet Hall
xvec_DEF = [XD, XE, XF]';
yvec_DEF = [YD, YE, YF]';

TDEF = [yvec_DEF'; -xvec_DEF'; ones(1,3)];
TDEF_inv = inv(TDEF);

U = [YA YB YC;
     -XA -XB -XC;
     1 1 1];

% Paramètres inertiels
% --------------------

% Données mises à jour le 10 juillet 2015
% Sphère
mS = 0.0080;           % kg
rS = 0.0039;           % m
JS = 2*mS*rS^2/5;     % solid kg m^2
% JS = 2*mS*rS^2/3;     % hollow

% Paramètres dérivés de la sphère
mSeff = mS+JS/rS^2;   % kg - masse effective de la sphère
mSg   = mS*g;         % N - poids de la sphère

% Plaque
mP = 425e-03;     % kg
Jx =  1169e-06;  % kg m^2
Jy =  Jx;             % kg m^2
Jz = 2329e-06;  % kg m^2

mtot = mP + sig*mS;   % kg - mase totale plaque + sphère

% Simulation
Vmax = 16.0;

% Paramètres électriques des actionneurs
% Données mises à jour le 10 juillet 2015
RR = 3.6;
LL = .115;
RA =  RR;
LA =  LL;
RB =  RR;
LB =  LL;
RC =  RR;
LC =  LL;
