load('Linearisation.mat')
equilibre
A = eval(subs(A));
B = eval(subs(B));
C = eval(subs(C));
D = eval(subs(D));

SP = eval(subs(SP));

% matrices découplées
A_sphere_x =  [0 1; 0 0];
B_sphere_x = [0;SP(1,2)];
C_sphere_x = eye(2);
D_sphere_x = [0;0];

A_sphere_y = [0 1; 0 0];
B_sphere_y = [0; SP(2,1)];
C_sphere_y = eye(2);
D_sphere_y = [0;0];

A_plaque = [zeros(3) eye(3) zeros(3);
            eval(subs(PP)) zeros(3) eval(subs(PC))*inv(U);
            zeros(3) zeros(3) eval(subs(CC))];
B_plaque = [zeros(3);zeros(3);eval(subs(CV))];

A_phi = [A_plaque(1,1) A_plaque(1,4) A_plaque(1,7);
         A_plaque(4,1) A_plaque(4,4) A_plaque(4,7);
         A_plaque(7,1) A_plaque(7,4) A_plaque(7,7)];

A_theta = [A_plaque(2,2) A_plaque(2,5) A_plaque(2,8);
         A_plaque(5,2) A_plaque(5,5) A_plaque(5,8);
         A_plaque(8,2) A_plaque(8,5) A_plaque(8,8)];

A_z = [A_plaque(3,3) A_plaque(3,6) A_plaque(3,9);
         A_plaque(6,3) A_plaque(6,6) A_plaque(6,9);
         A_plaque(9,3) A_plaque(9,6) A_plaque(9,9)];

B_phi = [0;0;B_plaque(7,1)];
B_theta = [0;0;B_plaque(8,2)];
B_z = [0;0;B_plaque(9,3)];

C_dec = [1 0 0];
D_dec = [0];

tf_sphere_x = tf(ss(A_sphere_x, B_sphere_x, C_sphere_x, D_sphere_x));
tf_sphere_y = tf(ss(A_sphere_y, B_sphere_y, C_sphere_y, D_sphere_y));

tf_phi = tf(ss(A_phi, B_phi, C_dec, D_dec));
tf_theta = tf(ss(A_theta, B_theta, C_dec, D_dec));
tf_z = tf(ss(A_z, B_z, C_dec, D_dec));

save('Plaque.mat','tf_phi','tf_theta','tf_z');