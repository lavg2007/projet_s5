function [tm0100] = findTm0100(FTBF,erp)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

dt = 1e-4;
t = 0:dt:30;
u = ones(size(t));

sim = lsim(FTBF,u,t);
tm0100 = find(sim >= erp+1,1)*dt;
 

end

