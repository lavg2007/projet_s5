function [sim, erp, t2 ] = rampinfo( FTBO, tmax)
dt = 1e-3;
t = 0:dt:tmax;
u = ones(size(t)).*t;

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
        erp = 1/(FTBO.Numerator{:}(end)/FTBO.Denominator{:}(end-classe));
        t2 = (find(abs(sim-erp) <= 2/100));
        
    case 2
        erp = 0;
        t2 = (find(abs(sim-erp) <= 2/100));
end
   
if isempty(t2)
    t2 = Inf;
end


for i = 1:1:length(t2)-2
    if sim(t2(i)) > sim(t2(i+1))
        t2 = t2(i)*dt;
        break;
    end
    
end



