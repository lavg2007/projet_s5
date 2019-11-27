function [ Gr ] = RetardPhaseBode1( FTBO, erp_s, wg_s, marge )

classe  = getClasse(FTBO);

Kvel_s = 1/erp_s;
Kvel = FTBO.Numerator{:}(end)/FTBO.Denominator{:}(end-classe);
K_s = Kvel_s/Kvel;

att = (norm(polyval(FTBO.Numerator{:},1i*wg_s)/polyval(FTBO.Denominator{:},1i*wg_s)));

if att == 1
    B = K_s;
else
    [numK_s, denK_s] = tfdata(FTBO*K_s,'v');
    B = (norm(polyval(numK_s,1i*wg_s)/polyval(denK_s,1i*wg_s)));
end
B;

T = marge/wg_s;

z = -1/T
p = -1/(B*T)
Kr = K_s/B;

Gr = tf([1 -z],[1 -p]);
Gr = Gr*Kr;

end

