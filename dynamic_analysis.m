clear;
load('PSF_Renewable.mat');
Sb = pant.baseMVA;
N_bus = length(pant.bus);
N_line = length(pant.branch);
dt = 1E-3;  Ndt = 5000;


% Fault initialization
id_fault1 = 3335;
dP_real1 = 355;

id_fault2 = 3159;
dP_real2 = 917;

id_fault3 = 3324;
dP_real3 = 550;

id_fault4 = 3036;
dP_real4 = 23;

id_fault5 = 3704;
dP_real5 = 34;

id_fault6 = 2537;
dP_real6 = 37.5;

% Parameter initialization
L = pant.bus(:,3)/Sb; 
G = zeros(N_bus,1);

is_producing = pant.gen(:,2) > 0;
id_gen = pant.gen(is_producing,1);
id_load = setdiff(1:length(L), id_gen)';

N_gen = length(id_gen);
N_load = length(id_load);

G(id_gen) = pant.gen(is_producing,2)/Sb; 
P = -L + G;
P = P - mean(P);

A = sparse([pant.branch(:,1); pant.branch(:,2)], [1:N_line 1:N_line], [ones(N_line,1); -ones(N_line,1)]);
b = -1i ./ pant.branch(:,4);
Ybus = conj(A * sparse(1:N_line,1:N_line,b) * A');
Q = zeros(N_bus,1);
V = ones(N_bus,1);
theta = zeros(N_bus,1);
[~,theta,~,~] = NRsolver(Ybus, V, theta, -P, Q, [], 9, 1E-11, 1000);
P_gen = P(id_gen);
P_load = P(id_load);

egdes = zeros(N_line,2);
line_start = pant.branch(:,1);
line_end = pant.branch(:,2);
for i=1:N_gen
    egdes(line_start == id_gen(i),1) = i;
    egdes(line_end == id_gen(i),2) = i;
end
for i=1:N_load
    egdes(line_start == id_load(i),1) = i + N_gen;
    egdes(line_end == id_load(i),2) = i + N_gen;
end
line_susceptance = 1 ./ pant.branch(:,4);

dP1 = -dP_real1 / Sb;
row_idx1 = find(id_gen == id_fault1);
P_gen(row_idx1) = P_gen(row_idx1) + dP1;

dP2 = -dP_real2 / Sb;
row_idx2 = find(id_gen == id_fault2);
P_gen(row_idx2) = P_gen(row_idx2) + dP2;

dP3 = -dP_real3 / Sb;
row_idx3 = find(id_gen == id_fault3);
P_gen(row_idx3) = P_gen(row_idx3) + dP3;

dP4 = -dP_real4 / Sb;
row_idx4 = find(id_gen == id_fault4);
P_gen(row_idx4) = P_gen(row_idx4) + dP4;

dP5 = -dP_real5 / Sb;
row_idx5 = find(id_gen == id_fault5);
P_gen(row_idx5) = P_gen(row_idx5) + dP5;

dP6 = -dP_real6 / Sb;
row_idx6 = find(id_gen == id_fault6);
P_gen(row_idx6) = P_gen(row_idx6) + dP6;

M_gen_orig = pant.gen_inertia(is_producing);
D_gen_orig = pant.gen_prim_ctrl(is_producing) + pant.load_freq_coef(id_gen);
D_load = pant.load_freq_coef(id_load);

omega_gen_init = zeros(N_gen,1);
theta_gen_init = theta(id_gen);
theta_load_init = theta(id_load);
 
incidence_mat = sparse([egdes(:,1); egdes(:,2)], [1:N_line 1:N_line], [ones(N_line,1); -ones(N_line,1)]);
G_graph = graph(pant.branch(:,1), pant.branch(:,2));
A_adj = adjacency(G_graph);
deg = sum(A_adj, 2);
D_inv = spdiags(1./deg, 0, N_bus, N_bus);
W = D_inv * A_adj;
 
M_gen = M_gen_orig;
D_gen = D_gen_orig;

% State initialization
omega_gen = omega_gen_init;
theta_gen = theta_gen_init;
theta_load = theta_load_init;

m = 10;
omega_t = zeros(N_gen, floor(Ndt/m));
delta_t = zeros(N_gen, floor(Ndt/m));
k = 1;

% Time-domain simulation
for i = 1:Ndt
    y = radau5(omega_gen, theta_gen, theta_load, ...
        M_gen, D_gen, D_load, P_gen, P_load, incidence_mat, line_susceptance, dt, 14, 1E-6);

    if mod(i, 200) == 0
        fprintf('Completed %d iterations...\n', i);
    end

    if mod(i,m) == 0
        omega_t(:,k) = y(1:N_gen);
        delta_t(:,k) = y(N_gen+1:2*N_gen);
        k = k + 1;
    end

    omega_gen = y(1:N_gen);
    theta_gen = y(N_gen+1:2*N_gen);
    theta_load = y(2*N_gen+1:end);
end
