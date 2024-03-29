%**************************************************************************
% 
% Fichier: CalculTFs.m
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
% R�sum�: Ce fichier permet le calcul des fonctions de transferts du projet
% en prenant les valeurs � l'�quilibre ainsi que leur repr�sentation avec 
% root locus. Aussi, les graphiques de la position des poles et z�ros des 
% diff�rentes fonctions en phi, theta, z et de la sph�re en x et en y.
% 
%**************************************************************************

% Valeur des �quations � l'�quilibre
load('Linearisation.mat')
equilibre
A = eval(subs(A));
B = eval(subs(B));
C = eval(subs(C));
D = eval(subs(D));

SP = eval(subs(SP));

% matrices d�coupl�es
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

% Fonction de transfert des matrices d�coupl�es
tf_sphere_x = tf(ss(A_sphere_x, B_sphere_x, C_sphere_x, D_sphere_x));
tf_sphere_y = tf(ss(A_sphere_y, B_sphere_y, C_sphere_y, D_sphere_y));

tf_phi = tf(ss(A_phi, B_phi, C_dec, D_dec));
tf_theta = tf(ss(A_theta, B_theta, C_dec, D_dec));
tf_z = tf(ss(A_z, B_z, C_dec, D_dec));

save('Plaque.mat','tf_phi','tf_theta','tf_z');

%% Valeurs propres

figure
pzmap(ss(A,B,C,D))
vp = eig(A)

%% Poles et zeros

figure()
rlocus(tf_phi)

figure()
rlocus(tf_theta)

figure()
rlocus(tf_z)

figure()
hold on
rlocus(tf_sphere_x(1))
rlocus(tf_sphere_x(2))

figure()
hold on
rlocus(tf_sphere_y(1))
rlocus(tf_sphere_y(2))

