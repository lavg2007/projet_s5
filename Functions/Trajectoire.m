function [t fx fy] = Trajectoire(tn, xn, yn)
% test d'erreurs dans les input
assert(numel(xn) == numel(yn), 'inputs must be same length')
assert(iscolumn(tn),'tn must be a column vector')
assert(iscolumn(xn),'xn must be a column vector')
assert(iscolumn(yn),'yn must be a column vector')


Ax = interpolation(tn,xn);
Ay = interpolation(tn,yn);

% mettre précision en input?
dt = 0.01;

t = [0:dt:tn(end)];
fx = zeros(size(t));
fy = zeros(size(t));

for i = 1:numel(tn)
    fx = fx + Ax(i)*t.^(i-1);
    fy = fy + Ay(i)*t.^(i-1);
end

end

function A = interpolation(xn, yn)
    N = numel(xn) 
    for i = 1:N
        P(:,i) = xn.^(i-1)
    end
        A = pinv(P)*yn;
end
