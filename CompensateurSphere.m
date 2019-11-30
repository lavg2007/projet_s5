%% calcul des compensateurs (sphere

% spécifications 
ts_s = 2; % entre 2 et 4
zeta_s = 0.9;
wn_s = -log(0.02)/(zeta_s*ts_s);

% calcul des paramètres
num_y = 7.007;
Kv_y = 2*zeta_s*wn_s/num_y;
Kp_y = wn_s^2/num_y;

num_x = -7.007;
Kv_x = 2*zeta_s*wn_s/num_x;
Kp_x = wn_s^2/num_x;