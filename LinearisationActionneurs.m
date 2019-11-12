% Linéarisation des actionneurs

close all
clear all
clc

%définir variable
syms I Ie DeltaI 
syms F Fe DeltaF
syms Z Ze DeltaZ

symbolique = 1

if symbolique == 1
    syms ae0 ae1 ae2 ae3 be1
    syms as0 as1 as2 as3
else
    load('CoefficientsActionneurs.mat')
end



fek = (I.^2 + be1*I)/(ae0+ae1*Z+ae2*Z.^2+ae3*Z.^3)

fsk = -1/(as0+as1*Z+as2*Z.^2+as3*Z.^3)




TaylorFek = subs(subs(fek, I, Ie), Z, Ze) + subs(subs(diff(fek, I), I, Ie), Z, Ze)*(I-Ie) + subs(subs(diff(fek, Z), I, Ie), Z, Ze)*(Z-Ze)

TaylorFsk = subs(fsk, Z, Ze) + subs(diff(fsk, Z), Z, Ze)*(Z-Ze)


F = TaylorFek + TaylorFsk


%Le point 4 ne s'applique pas

%Point 5
EquationEquilibre = subs(subs(F, I-Ie, 0), Z-Ze, 0)

pretty(EquationEquilibre)

EquationDynamique = F - EquationEquilibre

pretty(EquationDynamique)



