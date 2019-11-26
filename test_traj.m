clear
clc
close all


xn = [0 0.25 0.25 -0.25 -0.25 0.5 0.5 -0.5 -0.5]'*0.05;
yn = [0 0.25 -0.25 -0.25 0.25 0.5 -0.5 -0.5 0.5]'*0.05;
tn = [0:numel(xn)-1]';
% xn = [0 1 2 3 4 5]';
% yn = [0 2.608 1.350 -1.909 -2.338 0.6988]';


[t fx fy] = Trajectoire(tn,xn,yn)





figure

subplot(2,2,1)
hold on
plot(tn,xn,'x')
plot(t,fx)

subplot(2,2,2)
hold on
plot(tn,yn,'x')
plot(t,fy)

subplot(2,2,3:4)
hold on
plot(xn,yn,'x')
plot(fx,fy)

% xlim([-0.1 0.1]);
% ylim([-0.1 0.1]);