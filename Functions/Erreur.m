function [E, R2, RMS] = Erreur(xn,yn,h)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% calcul des erreurs

N = length(xn);

% E
E = sum((h-yn).^2);
% R2
R2 = sum((h-mean(yn)).^2)/sum((yn-mean(yn)).^2);
% RMS
RMS =sqrt(1/numel(xn)*sum((h-yn).^2));

end

