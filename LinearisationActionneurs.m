% Linéarisation des actionneurs

close all
clear all
clc

%définir variable
syms I IE DeltaI 
syms F Fe DeltaF
syms Z ZE DeltaZ

symbolique = 1

if symbolique == 1
    syms AE0 AE1 AE2 AE3 BE1
    syms AS0 AS1 AS2 AS3
else
    load('CoefficientsActionneurs.mat')
end



fek = (I.^2 + BE1*I)/(AE0+AE1*Z+AE2*Z.^2+AE3*Z.^3)

fsk = -1/(AS0+AS1*Z+AS2*Z.^2+AS3*Z.^3)



TaylorFek = subs(subs(fek, I, IE), Z, ZE) + subs(subs(diff(fek, I), I, IE), Z, ZE)*(I-IE) + subs(subs(diff(fek, Z), I, IE), Z, ZE)*(Z-ZE)
TaylorFsk = subs(fsk, Z, ZE) + subs(diff(fsk, Z), Z, ZE)*(Z-ZE)



F = TaylorFek + TaylorFsk



%Le point 4 ne s'applique pas

%Point 5
EquationEquilibre = subs(subs(F, I-IE, 0), Z-ZE, 0)

pretty(EquationEquilibre)

EquationDynamique = F - EquationEquilibre

pretty(EquationDynamique)

save('EquationLinearisation.mat','EquationDynamique')



