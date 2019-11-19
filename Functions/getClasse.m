function [ classe ] = getClasse( FTBO )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

classe  = 0;
for i = 0:1:3
    if (FTBO.Denominator{:}(end-i) == 0)
        classe = classe+1;
    else
        break
    end
end

end

