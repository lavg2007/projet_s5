
% varIAbles d'état
syms IA IB IC z Ay Ax dz dAy dAx Px Py dPx dPy



%entrées
syms Va Vb Vc

%sphere
syms mS mSeff g 

%plaque
syms Jx Jy mP 

%elec
syms LA RA RB LB RC LC

%actionneurs
syms XA YA ZA XB YB ZB XC YC ZC r_abc za zb zc

%capteurs
syms XE YE ZE XD YD ZD XF YF ZF r_def zd ze zf


%sous matrICeqs
syms PP PS PC SP CC CV Tdef A B C D


%calcul des moments
syms OA OB OC OS FA FB FC Fg T

OA = [XA YA 0];
OB = [XB YB 0];
OC = [XC YC 0];
OS = [Px Py 0];
Fg = [0 0 mS*g];
T = cross(OA, [0 0 FA]) + cross(OB, [0 0 FB]) + cross(OC, [0 0 FC]) + cross(OS, Fg) 

PS = [[0 mS*g];
      [-mS*g 0 ];
      [0 0]]

syms ae0 ae1 ae2 ae3 be1 as0 as1 as2 as3

syms FAeq FBeq FCeq Pxeq Pyeq IAeq IBeq ICeq zaeq zbeq zceq Pzeq Ayeq Axeq


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

%Axeq = 0;
%Ayeq = 0;

zaeq = Pzeq - XA*Ayeq + YA*Axeq;
zbeq = Pzeq - XB*Ayeq + YB*Axeq;
zceq = Pzeq - XC*Ayeq + YC*Axeq;


% pour courants positifs
FAe = (IAeq^2+be1*IAeq)/(ae0 + ae1*zaeq + ae2*zaeq^2 + ae3*zaeq^3);
FAs = -1/(as0 + as1*zaeq + as2*zaeq^2 + as3*zaeq^3);

FBe = (IBeq^2+be1*IBeq)/(ae0 + ae1*zbeq + ae2*zbeq^2 + ae3*zbeq^3);
FBs = -1/(as0 + as1*zbeq + as2*zbeq^2 + as3*zbeq^3);

FCe = (ICeq^2+be1*ICeq)/(ae0 + ae1*zceq + ae2*zceq^2 + ae3*zceq^3);
FCs = -1/(as0 + as1*zceq + as2*zceq^2 + as3*zceq^3);

FA = FAe + FAs;
FB = FBe + FBs;
FC = FCe + FCs;


syms d2z_z d2z_Ay d2z_Ax
d2z = FA/(mS + mP) + FB/(mS + mP) + FC/(mS + mP) + g

d2z_z = diff(d2z, Pzeq);
d2z_Ay = diff(d2z, Ayeq);
d2z_Ax = diff(d2z, Axeq);
d2z_IA = diff(d2z, IAeq);
d2z_IB = diff(d2z, IBeq);
d2z_IC = diff(d2z, ICeq);

d2Ax = (FA*YA + FB*YB + FC*YC + g*mS*Pyeq)/Jx

d2Ax_z = diff(d2Ax, Pzeq);
d2Ax_Ay = diff(d2Ax, Ayeq);
d2Ax_Ax = diff(d2Ax, Axeq);
d2Ax_IA = diff(d2Ax, IAeq);
d2Ax_IB = diff(d2Ax, IBeq);
d2Ax_IC = diff(d2Ax, ICeq);

d2Ay = (-FA*XA-FB*XB-FC*XC-g*mS*Pxeq)/Jy

d2Ay_z = diff(d2Ay, Pzeq);
d2Ay_Ay = diff(d2Ay, Ayeq);
d2Ay_Ax = diff(d2Ay, Axeq);
d2Ay_IA = diff(d2Ay, IAeq);
d2Ay_IB = diff(d2Ay, IBeq);
d2Ay_IC = diff(d2Ay, ICeq);


%FA = 
PP = [[d2Ax_Ax d2Ax_Ay d2Ax_z];
      [d2Ay_Ax d2Ay_Ay d2Ay_z];
      [d2z_Ax d2z_Ay d2z_z]]

PC = [[d2Ax_IA d2Ax_IB d2Ax_IC];
      [d2Ay_IA d2Ay_IB d2Ay_IC];
      [d2z_IA d2z_IB d2z_IC]]

%positions




SP = [0 -mS*g/mSeff 0 ;
      mS*g/mSeff 0 0 ]

      
CC = [-RA/LA 0 0 ;
      0 -RB/LB 0 ;
      0 0 -RC/LC]

CV = [1/LA 0 0;
      0 1/LB 0;
      0 0 1/LC]

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



save('Linearisation.mat','A','B','C','D')

%% D�couplage de la plaque

