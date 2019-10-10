%% mesures avec -1A

load('Fe_attraction.mat')

I1 = -1;
be1 = 13.029359254409743;

z1_1 = z_m1A;
z1_0 = z1_1.^0;
z1_2 = z1_1.^2;
z1_3 = z1_1.^3;

Y1 = ((I1^2+be1*abs(I1))*sign(I1))./Fe_m1A;

X1 = [z1_0 z1_1 z1_2 z1_3];

a1 = pinv(X1)*Y1;
ae1_0 = a1(1);
ae1_1 = a1(2);
ae1_2 = a1(3);
ae1_3 = a1(4);

Fe1 = ((I1^2+be1*abs(I1))*sign(I1))./(ae1_0.*z1_0 + ae1_1.*z1_1 + ae1_2.*z1_2 + ae1_3.*z1_3);

figure(1)
subplot(2,1,1)
plot(z_m1A,Fe1)
title('Simulation selon les valeurs calculees avec -1A')
subplot(2,1,2)
plot(z_m1A,Fe_m1A)
title('Simulation selon les valeurs mesurees avec -1A')

%% mesures avec -2A

load('Fe_attraction.mat')

I2 = -2;
be1 = 13.029359254409743;

z2_1 = z_m2A;
z2_0 = z2_1.^0;
z2_2 = z2_1.^2;
z2_3 = z2_1.^3;

Y2 = ((I2^2+be1*abs(I2))*sign(I2))./Fe_m2A;

X2 = [z2_0 z2_1 z2_2 z2_3];

a2 = pinv(X2)*Y2;
ae2_0 = a2(1);
ae2_1 = a2(2);
ae2_2 = a2(3);
ae2_3 = a2(4);

Fe2 = ((I2^2+be1*abs(I2))*sign(I2))./(ae2_0.*z2_0 + ae2_1.*z2_1 + ae2_2.*z2_2 + ae2_3.*z2_3);

figure(2)
subplot(2,1,1)
plot(z_m2A,Fe2)
title('Simulation selon les valeurs calculees avec -2A')
subplot(2,1,2)
plot(z_m2A,Fe_m2A)
title('Simulation selon les valeurs mesurees avec -2A')

%% mesures avec Fs

load('Fs.mat')

z3_1 = z_pos;
z3_0 = z3_1.^0;
z3_2 = z3_1.^2;
z3_3 = z3_1.^3;

Y3 = -1./Fs;

X3 = [z3_0 z3_1 z3_2 z3_3];

a3 = pinv(X3)*Y3;
ae3_0 = a3(1);
ae3_1 = a3(2);
ae3_2 = a3(3);
ae3_3 = a3(4);

Fs_sim = -1./(ae3_0.*z3_0 + ae3_1.*z3_1 + ae3_2.*z3_2 + ae3_3.*z3_3);

figure(3)
subplot(2,1,1)
plot(z_pos,Fs_sim)
axis([0 0.035 -16 0])
title('Simulation selon les valeurs calculees')
subplot(2,1,2)
plot(z_pos,Fs)
title('Simulation selon les valeurs mesurees')
