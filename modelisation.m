clc
clear

% variables d'état
syms ia ib ic z theta phi dz dtheta dphi Px Py dPx dPy

%sous matrices
syms PP Px PC SP CC CV Tdef A B C D



%entrées
syms Va Vb Vc

%sphere
syms masseS meff g 

%plaque
syms Jxy masseP 

%elec
syms La Ra Rb Lb Rc Lc

%actionneurs
syms XA YA ZA XB YB ZB XC YC ZC r_abc za zb zc

%capteurs
syms XE YE ZE XD YD ZD XF YF ZF r_def zd ze zf



%calcul des moments
syms OA OB OC OS FA FB FC Fg T
OA = [XA 0 0];
OB = [XB YB 0];
OC = [XC YC 0];
OS = [Px Py 0];
Fg = [0 0 masseS*g];
T = cross(OA, [0 0 FA]) + cross(OB, [0 0 FB]) + cross(OC, [0 0 FC]) + cross(OS, Fg) 

Px = [[0 masseS*g];
      [-masseS*g 0 ];
      [0 0]]

za = z - r_abc*(sind(30)*sin(theta));
zb = z + r_abc*(sind(30)*sin(theta) + sind(60)*sin(phi));
zc = z + r_abc*(sind(30)*sin(theta) - sind(60)*sin(phi));

syms ae0 ae1 ae2 ae3 be1 as0 as1 as2 as3

syms FAe FBe FCe Pxe Pye iae ibe ice zae zbe zce zeq thetaeq phieq


za = z - XA*theta + YA*phi;
zb = z - XB*theta + YB*phi;
zc = z - XC*theta + YC*phi;
zd = z - XD*theta + YD*phi;
ze = z - XE*theta + YE*phi;
zf = z - XF*theta + YF*phi;
da = za - ZA;
db = zb - ZB;
dc = zc - ZC;
dd = zd - ZD;
de = ze - ZE;
df = zf - ZF;

%phieq = 0;
%thetaeq = 0;

zae = zeq - XA*thetaeq + YA*phieq;
zbe = zeq - XB*thetaeq + YB*phieq;
zce = zeq - XC*thetaeq + YC*phieq;


% pour courants positifs
Fae = (iae^2+be1*iae)/(ae0 + ae1*zae + ae2*zae^2 + ae3*zae^3);
Fas = -1/(as0 + as1*zae + as2*zae^2 + as3*zae^3);

Fbe = (ibe^2+be1*ibe)/(ae0 + ae1*zbe + ae2*zbe^2 + ae3*zbe^3);
Fbs = -1/(as0 + as1*zbe + as2*zbe^2 + as3*zbe^3);

Fce = (ice^2+be1*ice)/(ae0 + ae1*zce + ae2*zce^2 + ae3*zce^3);
Fcs = -1/(as0 + as1*zce + as2*zce^2 + as3*zce^3);

Fa = Fae + Fas;
Fb = Fbe + Fbs;
Fc = Fce + Fcs;


syms d2z_z d2z_theta d2z_phi
d2z = Fa/(masseS + masseP) + Fb/(masseS + masseP) + Fc/(masseS + masseP) + g;

d2z_z = diff(d2z, zeq);
d2z_theta = diff(d2z, thetaeq);
d2z_phi = diff(d2z, phieq);
d2z_ia = diff(d2z, iae);
d2z_ib = diff(d2z, ibe);
d2z_ic = diff(d2z, ice);

d2phi = (Fb*YC + Fc*YC + g*masseS*Pye)/Jxy;

d2phi_z = diff(d2phi, zeq);
d2phi_theta = diff(d2phi, thetaeq);
d2phi_phi = diff(d2phi, phieq);
d2phi_ia = diff(d2phi, iae);
d2phi_ib = diff(d2phi, ibe);
d2phi_ic = diff(d2phi, ice);

d2theta = (-Fa*XA-Fb*XB-Fc*XC-g*masseS*Pxe)/Jxy;

d2theta_z = diff(d2theta, zeq);
d2theta_theta = diff(d2theta, thetaeq);
d2theta_phi = diff(d2theta, phieq);
d2theta_ia = diff(d2theta, iae);
d2theta_ib = diff(d2theta, ibe);
d2theta_ic = diff(d2theta, ice);


%Fa = 
PP = [[d2phi_phi d2phi_theta d2phi_z];
      [d2theta_phi d2theta_theta d2theta_z];
      [d2z_phi d2z_theta d2z_z]]; %;

PC = [[d2phi_ia d2phi_ib d2phi_ic];
      [d2theta_ia d2theta_ib d2theta_ic];
      [d2z_ia d2z_ib d2z_ic]]; %;

%positions




SP = [0 -masseS*g/meff 0 ;
      masseS*g/meff 0 0 ];

      
CC = [-Ra/La 0 0 ;
      0 -Rb/Lb 0 ;
      0 0 -Rc/Lc];

CV = [1/La 0 0;
      0 1/Lb 0;
      0 0 1/Lc];

Tdef = [[dd 0 0];
        [0 de 0];
        [0 0 df]];

A = [[zeros([3,3]) eye(3) zeros([3,2]) zeros([3,2]) zeros([3,3]) ]; 
     [PP zeros([3,3]) Px zeros([3,2]) PC ];
     [zeros([2,3]) zeros([2,3]) zeros([2,2]) eye(2) zeros([2,3]) ];
     [SP zeros([2,3]) zeros([2,2]) zeros([2,2]) zeros([2,3]) ];
     [zeros([3,3]) zeros([3,3]) zeros([3,2]) zeros([3,2]) CC ]];

A = subs(A, [thetaeq, phieq], [0, 0]);
%A = subs(A, [XA, YA], [r_abc, 0]);
%A = subs(A, [XB, YB], [-r_abc*sind(30), r_abc*cosd(30)]);
%A = subs(A, [XC, YC], [-r_abc*sind(30), -r_abc*cosd(30)]);   

     
B = [[zeros([3,3])];
    [zeros([3,3])];
    [zeros([2,3])];
    [zeros([2,3])];
    CV ];
    
C = [[Tdef zeros([3,3]) zeros([3,4]) zeros([3,3])];
      [zeros([4,3]) zeros([4,3]) eye(4) zeros([4,3])]];
      
D = zeros([7,3]);

%détermination des conditions d'équilibre

%cas 1 theta = phi = 0, z = cste, avec sphère

syms Vae Vbe Vce Veq
eq_vars1 = [ iae ibe ice  XA YA XB YB XC YC ];
eq_values1 = [ Vae/Ra Vbe/Rb Vce/Rc r_abc 0 -r_abc*sind(30) r_abc*cosd(30) -r_abc*sind(30) -r_abc*cosd(30)];
eq_vars2 = [g Ra Rb Rc La Lb Lc thetaeq phieq Jxy masseP masseS r_abc ];
eq_values2 = [9.807 3.6 3.6 3.6 0.115 0.115 0.115 0 0 1347 442 8.0 95.2 ];

eq1 = Fa + Fb + Fc == (masseS + masseP)*g;
eq1 = subs(eq1, eq_vars1, eq_values1);
d2zeq_1 = vpa(subs(eq1, eq_vars2, eq_values2),3)


eq2 = (Fb*YB + Fc*YC) == -g*masseS*Pye;
eq2 = subs(eq2, eq_vars1, eq_values1);
d2phieq_1 = vpa(subs(eq2, eq_vars2, eq_values2),3)


eq3 = (-Fa*XA - Fb*XB - Fc*XC) == -g*masseS*Pxe;
eq3 = subs(eq3, eq_vars1, eq_values1);
d2thetaeq_1 = vpa(subs(eq3, eq_vars2, eq_values2), 3)

%cas 2 theta = phi = 0, z = cste, sans sphère

eq_vars1 = [iae ibe ice XA YA XB YB XC YC];
eq_values1 = [Veq/Ra Veq/Rb Veq/Rc r_abc 0 -r_abc*sind(30) r_abc*cosd(30) -r_abc*sind(30) -r_abc*cosd(30)];
eq_vars2 = [g Ra Rb Rc La Lb Lc Pxe Pye thetaeq phieq Jxy masseP masseS r_abc];
eq_values2 = [9.807 3.6 3.6 3.6 0.115 0.115 0.115 0 0 0 0 1347 442 8.0 95.2];

eq1 = subs(eq1, eq_vars1, eq_values1);
d2zeq_2 = vpa(subs(eq1, eq_vars2, eq_values2),3)


eq2 = subs(eq2, eq_vars1, eq_values1);
d2phieq_2 = subs(eq2, eq_vars2, eq_values2)


eq3 = subs(eq3, eq_vars1, eq_values1);
d2thetaeq_2 = subs(eq3, eq_vars2, eq_values2)


%cas 3

eq_vars1 = [iae ibe ice XA YA XB YB XC YC];
eq_values1 = [Vae/Ra Vbe/Rb Vce/Rc r_abc 0 -r_abc*sind(30) r_abc*cosd(30) -r_abc*sind(30) -r_abc*cosd(30)];
eq_vars2 = [g Ra Rb Rc La Lb Lc Pxe Pye Jxy masseP masseS r_abc];
eq_values2 = [9.807 3.6 3.6 3.6 0.115 0.115 0.115 0 0 1347 442 0 95.2];

eq1 = subs(eq1, eq_vars1, eq_values1);
d2zeq_3 = vpa(subs(eq1, eq_vars2, eq_values2),3)


eq2 = subs(eq2, eq_vars1, eq_values1);
d2phieq_3 = subs(eq2, eq_vars2, eq_values2)


eq3 = subs(eq3, eq_vars1, eq_values1);
d2thetaeq_3 = subs(eq3, eq_vars2, eq_values2)

