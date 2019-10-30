
%Modelisation
sig = 1;         % Pr�sence (1) ou non (0) de la sph�re
xSeq = 0.000;      % Position x de la sph�re � l'�quilibre en metres
ySeq = 0.000;      % Position y de la sph�re � l'�quilibre en metres
Pyeq = ySeq;
Pxeq = xSeq;
%Point d'op�ration choisi pour la plaque
Axeq = 0;               %en degres
Ayeq = 0;               %en degres
Pzeq = .015;            %en metres
bancEssaiConstantes
load('CoefficientsActionneurs.mat')
syms VAeq VBeq VCeq IAeq IBeq ICeq FAeq FBeq FCeq

d2zeq =  vpa(FAeq/mtot + FBeq/mtot + FCeq/mtot + g,5);
d2Axeq = vpa((FAeq*YA + FBeq*YB + FCeq*YC + g*mS*Pyeq)/Jx,5);
d2Ayeq = vpa((-FAeq*XA-FBeq*XB-FCeq*XC-g*mS*Pxeq)/Jy,5);

ZAeq = Pzeq - XA*deg2rad(Ayeq) + YA*deg2rad(Axeq) ;
ZBeq = Pzeq - XB*deg2rad(Ayeq) + YC*deg2rad(Axeq) ;
ZCeq = Pzeq - XC*deg2rad(Ayeq) + YC*deg2rad(Axeq) ;

[FAeq FBeq FCeq] = solve([d2zeq d2Axeq d2Ayeq]);

eqFA = sign(IAeq)*(IAeq^2 + be1*abs(IAeq))/(ae0 + ZAeq*ae1 + ZAeq^2*ae2 + ZAeq^3*ae3)  == FAeq + 1/(as0 + ZAeq*as1 + ZAeq^2*as2 + ZAeq^3*as3);
eqFB = sign(IBeq)*(IBeq^2 + be1*abs(IBeq))/(ae0 + ZBeq*ae1 + ZBeq^2*ae2 + ZBeq^3*ae3)  == FBeq + 1/(as0 + ZBeq*as1 + ZBeq^2*as2 + ZBeq^3*as3);
eqFC = sign(IBeq)*(ICeq^2 + be1*abs(ICeq))/(ae0 + ZCeq*ae1 + ZCeq^2*ae2 + ZCeq^3*ae3) == FCeq + 1/(as0 + ZCeq*as1 + ZCeq^2*as2 + ZCeq^3*as3); 

[IAeq IBeq ICeq] = solve([eqFA eqFB eqFC]);

VAeq = IAeq/RA
VBeq = IBeq/RB
VCeq = ICeq/RC
