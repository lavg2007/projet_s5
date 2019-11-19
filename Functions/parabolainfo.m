function [ sim, erp, t2 ] = parabolainfo( FTBO, tmax)
dt = 1e-3;
t = 0:dt:tmax;
u = ones(size(t)).*t.^2/2;

FTBF = feedback(FTBO,1);
sim = u- lsim(FTBF,u,t).';

erp = NaN;
t2 = NaN;

classe = getClasse(FTBO);

switch classe
    
    case 0
        erp = Inf;
        t2 = Inf;
        
    case 1
        erp = Inf;
        t2 =  Inf;
        
    case 2
        erp = 1/(FTBO.Numerator{:}(end)/FTBO.Denominator{:}(end-classe));
        t2 = (find(abs(sim-erp) <= 2/100,1))*dt;

        
end

if isempty(t2)
    t2 = Inf;   
end



