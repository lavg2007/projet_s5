% angles

Mp_ang = 5;
ts_ang = 0.03;
tp_ang = 0.025;
tm10_90 = 0.02;

phi_ang = atan(-pi/log(Mp_ang/100))
zeta_ang = cos(phi_ang)

wn1 = -log(0.02)/(ts_ang*zeta_ang);
wn2 = pi/(tp_ang*sqrt(1-zeta_ang^2));
wn3 = (1 + 1.1*zeta_ang + 1.4*zeta_ang^2)/tm10_90;

wn_ang = max([wn1 wn2 wn3]);
wa_ang = wn_ang*sqrt(1-zeta^2);

% avance de phase phi


[num_phi den_phi] = tfdata(tf_phi, 'v')
p_des = -zeta_ang*wn_ang + j*wa_ang

[Ga_phi Ka_phi] = AvanceDePhase(num_phi, den_phi, phi_ang, wn_ang, zeta_ang, wa_ang, p_des, 0)
G1_phi = series(Ga_phi, tf_phi)

[num1_phi den1_phi] = tfdata(G1_phi, 'v')

[Gpi_phi] = ProportionnelIntegralV1(num1_phi, den1_phi, p_des);
G2_phi = series(Gpi_phi, G1_phi)

figure
hold on
rlocus(tf_phi)
plot(p_des, 'p')

figure
hold on
rlocus(G1_phi)
plot(p_des, 'p')

figure
step(feedback(G1_phi,1),feedback(G2_phi,1))

% avance de phase theta

% z