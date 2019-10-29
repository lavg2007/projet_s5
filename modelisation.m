clc
clear

% varIAbles d'état
syms IA IB IC z Ay Ax dz dAy dAx Px Py dPx dPy



%entrées
syms Va Vb Vc

%sphere
syms masseS meff g 

%plaque
syms inertiePx inertiePy masseP 

%elec
syms La Ra Rb Lb Rc Lc

%actionneurs
syms XA YA ZA XB YB ZB XC YC ZC r_abc za zb zc

%capteurs
syms XE YE ZE XD YD ZD XF YF ZF r_def zd ze zf


%sous matrIC_eqs
syms PP PS PC SP CC CV Tdef A B C D


%calcul des moments
syms OA OB OC OS FA FB FC Fg T

OA = [XA YA 0];
OB = [XB YB 0];
OC = [XC YC 0];
OS = [Px Py 0];
Fg = [0 0 masseS*g];
T = cross(OA, [0 0 FA]) + cross(OB, [0 0 FB]) + cross(OC, [0 0 FC]) + cross(OS, Fg) 

PS = [[0 masseS*g];
      [-masseS*g 0 ];
      [0 0]]

syms ae0 ae1 ae2 ae3 be1 as0 as1 as2 as3

syms FA_eq FB_eq FC_eq Px_eq Py_eq IA_eq IB_eq IC_eq za_eq zb_eq zc_eq z_eq Ay_eq Ax_eq


za = z - XA*Ay + YA*Ax;
zb = z - XB*Ay + YB*Ax;
zc = z - XC*Ay + YC*Ax;
zd = z - XD*Ay + YD*Ax;
ze = z - XE*Ay + YE*Ax;
zf = z - XF*Ay + YF*Ax;
da = za - ZA;
db = zb - ZB;
dc = zc - ZC;
dd = zd - ZD;
de = ze - ZE;
df = zf - ZF;

%Ax_eq = 0;
%Ay_eq = 0;

za_eq = z_eq - XA*Ay_eq + YA*Ax_eq;
zb_eq = z_eq - XB*Ay_eq + YB*Ax_eq;
zc_eq = z_eq - XC*Ay_eq + YC*Ax_eq;


% pour courants positifs
FA_eq = (IA_eq^2+be1*IA_eq)/(ae0 + ae1*za_eq + ae2*za_eq^2 + ae3*za_eq^3);
FAs = -1/(as0 + as1*za_eq + as2*za_eq^2 + as3*za_eq^3);

FB_eq = (IB_eq^2+be1*IB_eq)/(ae0 + ae1*zb_eq + ae2*zb_eq^2 + ae3*zb_eq^3);
FBs = -1/(as0 + as1*zb_eq + as2*zb_eq^2 + as3*zb_eq^3);

FC_eq = (IC_eq^2+be1*IC_eq)/(ae0 + ae1*zc_eq + ae2*zc_eq^2 + ae3*zc_eq^3);
FCs = -1/(as0 + as1*zc_eq + as2*zc_eq^2 + as3*zc_eq^3);

FA = FA_eq + FAs;
FB = FB_eq + FBs;
FC = FC_eq + FCs;


syms d2z_z d2z_Ay d2z_Ax
d2z = FA/(masseS + masseP) + FB/(masseS + masseP) + FC/(masseS + masseP) + g;

d2z_z = diff(d2z, z_eq);
d2z_Ay = diff(d2z, Ay_eq);
d2z_Ax = diff(d2z, Ax_eq);
d2z_IA = diff(d2z, IA_eq);
d2z_IB = diff(d2z, IB_eq);
d2z_IC = diff(d2z, IC_eq);

d2Ax = (FB*YC + FC*YC + g*masseS*Py_eq)/inertiePx;

d2Ax_z = diff(d2Ax, z_eq);
d2Ax_Ay = diff(d2Ax, Ay_eq);
d2Ax_Ax = diff(d2Ax, Ax_eq);
d2Ax_IA = diff(d2Ax, IA_eq);
d2Ax_IB = diff(d2Ax, IB_eq);
d2Ax_IC = diff(d2Ax, IC_eq);

d2Ay = (-FA*XA-FB*XB-FC*XC-g*masseS*Px_eq)/inertiePy;

d2Ay_z = diff(d2Ay, z_eq);
d2Ay_Ay = diff(d2Ay, Ay_eq);
d2Ay_Ax = diff(d2Ay, Ax_eq);
d2Ay_IA = diff(d2Ay, IA_eq);
d2Ay_IB = diff(d2Ay, IB_eq);
d2Ay_IC = diff(d2Ay, IC_eq);


%FA = 
PP = [[d2Ax_Ax d2Ax_Ay d2Ax_z];
      [d2Ay_Ax d2Ay_Ay d2Ay_z];
      [d2z_Ax d2z_Ay d2z_z]]

PC = [[d2Ax_IA d2Ax_IB d2Ax_IC];
      [d2Ay_IA d2Ay_IB d2Ay_IC];
      [d2z_IA d2z_IB d2z_IC]]

%positions




SP = [0 -masseS*g/meff 0 ;
      masseS*g/meff 0 0 ]

      
CC = [-Ra/La 0 0 ;
      0 -Rb/Lb 0 ;
      0 0 -Rc/Lc]

CV = [1/La 0 0;
      0 1/Lb 0;
      0 0 1/Lc]

Tdef = [[YD -XD 1];
        [YE -XE 1];
        [YF -XF 1]]

A = [[zeros([3,3]) eye(3) zeros([3,2]) zeros([3,2]) zeros([3,3]) ]; 
     [PP zeros([3,3]) PS zeros([3,2]) PC ];
     [zeros([2,3]) zeros([2,3]) zeros([2,2]) eye(2) zeros([2,3]) ];
     [SP zeros([2,3]) zeros([2,2]) zeros([2,2]) zeros([2,3]) ];
     [zeros([3,3]) zeros([3,3]) zeros([3,2]) zeros([3,2]) CC ]]

     
B = [[zeros([3,3])];
    [zeros([3,3])];
    [zeros([2,3])];
    [zeros([2,3])];
    CV ]
    
C = [[Tdef zeros([3,3]) zeros([3,4]) zeros([3,3])];
      [zeros([4,3]) zeros([4,3]) eye(4) zeros([4,3])]]
      
D = zeros([7,3])



%% D�couplage de la plaque

