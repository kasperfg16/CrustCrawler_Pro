%Dynamics for crustcrawler
%Gruppe 364 3. semester 2020
%% Setting up symbolic values (for symbolic calculation)
syms g I_xx_1 I_xy_1 I_xz_1 I_xy_1 I_yy_1 I_yz_1 I_xz_1 I_yz_1 I_zz_1
syms I_xx_2 I_xy_2 I_xz_2 I_xy_2 I_yy_2 I_yz_2 I_xz_2 I_yz_2 I_zz_2
syms I_xx_3 I_xy_3 I_xz_3 I_xy_3 I_yy_3 I_yz_3 I_xz_3 I_yz_3 I_zz_3

syms l1 lc1 l2 lc2 l3 lc3 

syms m1 m2 m3

syms th1 th2 th3
syms thdot1 thdot2 thdot3
syms thdotdot1 thdotdot2 thdotdot3

%% Gravity vector

g_vec = [0 
     0  
     g];
 
%% Inertia tensors
IC_1 = [I_xx_1  I_xy_1  I_xz_1  
        I_xy_1  I_yy_1  I_yz_1 
        I_xz_1  I_yz_1  I_zz_1];
        
IC_2 = [I_xx_2  I_xy_2  I_xz_2
        I_xy_2  I_yy_2  I_yz_2
        I_xz_2  I_yz_2  I_zz_2];
        
IC_3 = [I_xx_3  I_xy_3  I_xz_3 
        I_xy_3  I_yy_3  I_yz_3
        I_xz_3  I_yz_3  I_zz_3];
     
%% Ratation matrices;
R_01 = [ cos(th1)  -sin(th1)  0 
         sin(th1)  cos(th1)   0
         0          0         1];
     
R_12 = [ -sin(th2)  -cos(th2)  0 
           0          0        -1
          cos(th2)   -sin(th2)  0];
 
R_23 = [ cos(th3)   -sin(th3)  0 
         sin(th3)   cos(th3)   0
         0              0      1];
 
R_02 = R_01 * R_12;

R_03 = R_01 * R_12 * R_23;

%% Unit vectors
e1 = [1  
      0  
      0];

e3 = [0  
      0  
      1];
  
%% Positions vectors
Pv1 = R_01 * (l1 * e3);
Pv2 = R_02 * (l2 * e1);

PvC1 = R_01 * lc1 * e3;
PvC2 = R_02 * lc2 * e1;
PvC3 = R_03 * lc3 * e1;

PC1 = PvC1;
PC2 = PvC2 + Pv1;
PC3 = PvC3 + Pv1 + Pv2;

%% Angular velocities
Om11 = thdot1 * e3;
Om22 = inv(R_12) * Om11 + thdot2 * e3;
Om33 = inv(R_23) * Om22 + thdot3 * e3;

Om01 = R_01 * thdot1 * e3;
Om02 = R_01 * Om11 + R_02 * thdot2 * e3;
Om03 = R_02 * Om22 + R_03 * thdot3 * e3;

%% Linear velocities
Vc1 = cross(Om01,PC1);
Vc2 = cross(Om02,PC2);
Vc3 = cross(Om03,PC3);

%% Kinetic energies
T1 = 1/2 * m1 * transpose(Vc1) * Vc1 + 1/2 * transpose(Om11) * IC_1 ...
    * Om11;   
T2 = 1/2 * m2 * transpose(Vc2) * Vc2 + 1/2 * transpose(Om22) * IC_2 ...
    * Om22;   
T3 = 1/2 * m3 * transpose(Vc3) * Vc3 + 1/2 * transpose(Om33) * IC_3 ...
    * Om33;   

%% potential energies
V1 = -m1 * transpose(g_vec) * PC1;
V2 = -m2 * transpose(g_vec) * PC2;
V3 = -m3 * transpose(g_vec) * PC3;

%% The lagrangian
T_total = simplify(T1 + T2 + T3);
V_total = simplify(V1 + V2 + V3);

Langragian_system = T_total-V_total;

%% Torques
%tau 1
diff_L_th1      = diff(Langragian_system,th1);
diff_L_thdot1   = diff(Langragian_system,thdot1);
diff_time_diff_L_th1_dot...
    = diff(diff_L_thdot1,th1) * thdot1      ...
    + diff(diff_L_thdot1,th2) * thdot2      ...
    + diff(diff_L_thdot1,th3) * thdot3      ...
    + diff(diff_L_thdot1,thdot1) * thdotdot1...
    + diff(diff_L_thdot1,thdot2) * thdotdot2...
    + diff(diff_L_thdot1,thdot3) * thdotdot3;

tau_1 = simplify(diff_time_diff_L_th1_dot - diff_L_th1)

%tau 2
diff_L_th2      = diff(Langragian_system,th2);
diff_L_thdot2   = diff(Langragian_system,thdot2);
diff_time_diff_L_th2_dot...
    = diff(diff_L_thdot2,th1) * thdot1      ...
    + diff(diff_L_thdot2,th2) * thdot2      ...
    + diff(diff_L_thdot2,th3) * thdot3      ...
    + diff(diff_L_thdot2,thdot1) * thdotdot1...
    + diff(diff_L_thdot2,thdot2) * thdotdot2...
    + diff(diff_L_thdot2,thdot3) * thdotdot3;

tau_2 = simplify(diff_time_diff_L_th2_dot - diff_L_th2)

%tau 3
diff_L_th3      = diff(Langragian_system,th3);
diff_L_thdot3   = diff(Langragian_system,thdot3);
diff_time_diff_L_th3_dot...
    = diff(diff_L_thdot3,th1) * thdot1      ...
    + diff(diff_L_thdot3,th2) * thdot2      ...
    + diff(diff_L_thdot3,th3) * thdot3      ...
    + diff(diff_L_thdot3,thdot1) * thdotdot1...
    + diff(diff_L_thdot3,thdot2) * thdotdot2...
    + diff(diff_L_thdot3,thdot3) * thdotdot3;

tau_3 = simplify(diff_time_diff_L_th3_dot - diff_L_th3)

%% Statespace equation terms
MassMatrix =[
    simplify(diff(diff(T_total,thdot1),thdot1)),...
    simplify(diff(diff(T_total,thdot2),thdot1)),...
    simplify(diff(diff(T_total,thdot3),thdot1));...
    ...
    simplify(diff(diff(T_total,thdot1),thdot2)),...
    simplify(diff(diff(T_total,thdot2),thdot2)),...
    simplify(diff(diff(T_total,thdot3),thdot2));...
    ...
    simplify(diff(diff(T_total,thdot1),thdot3)),...
    simplify(diff(diff(T_total,thdot2),thdot3)),...
    simplify(diff(diff(T_total,thdot3),thdot3))
]

VelocityVector = [
      I_yz_3*thdot2^2*cos(th2 + th3)            ... 
    - I_yz_3*thdot3^2*cos(th2 + th3)            ...
    - I_xz_3*thdot2^2*sin(th2 + th3)            ...
    - I_xz_3*thdot3^2*sin(th2 + th3)            ...
    - I_yz_2*thdot2^2*cos(th2)                  ...
    - I_xz_2*thdot2^2*sin(th2)                  ...
    - I_xx_3*thdot1*thdot2*sin(2*th2 + 2*th3)   ...
    - I_xx_3*thdot1*thdot3*sin(2*th2 + 2*th3)   ...
    + I_yy_3*thdot1*thdot2*sin(2*th2 + 2*th3)   ...
    + I_yy_3*thdot1*thdot3*sin(2*th2 + 2*th3)   ...
    - 2*I_yz_3*thdot2*thdot3*cos(th2 + th3)     ...
    - 2*I_xz_3*thdot2*thdot3*sin(th2 + th3)     ...
    - 2*I_xy_2*thdot1*thdot2*cos(2*th2)         ...
    - I_xx_2*thdot1*thdot2*sin(2*th2)           ...
    + I_yy_2*thdot1*thdot2*sin(2*th2)           ...
    - 2*I_xy_3*thdot1*thdot2*cos(2*th2 + 2*th3) ...
    - 2*I_xy_3*thdot1*thdot3*cos(2*th2 + 2*th3) ...
    + l2^2*m3*thdot1*thdot2*sin(2*th2)          ...
    + lc2^2*m2*thdot1*thdot2*sin(2*th2)         ...
    + lc3^2*m3*thdot1*thdot2*sin(2*th2 + 2*th3) ...
    + lc3^2*m3*thdot1*thdot3*sin(2*th2 + 2*th3) ...
    - l2*lc3*m3*thdot1*thdot3*sin(th3)          ...
    + 2*l2*lc3*m3*thdot1*thdot2*sin(2*th2 + th3)...
    + l2*lc3*m3*thdot1*thdot3*sin(2*th2 + th3)  ...
    ;...
       I_xy_2*thdot1^2*cos(2*th2)               ...
    + (I_xx_2*thdot1^2*sin(2*th2))/2            ...
    - (I_yy_2*thdot1^2*sin(2*th2))/2            ...
    + I_xy_3*thdot1^2*cos(2*th2 + 2*th3)        ...
    + (I_xx_3*thdot1^2*sin(2*th2 + 2*th3))/2    ...
    - (I_yy_3*thdot1^2*sin(2*th2 + 2*th3))/2    ...
    - (l2^2*m3*thdot1^2*sin(2*th2))/2           ...
    - (lc2^2*m2*thdot1^2*sin(2*th2))/2          ...
    - (lc3^2*m3*thdot1^2*sin(2*th2 + 2*th3))/2  ...
    - l1*lc3*m3*thdot2^2*sin(th2 + th3)         ...
    - l1*lc3*m3*thdot3^2*sin(th2 + th3)         ...
    - l1*l2*m3*thdot2^2*sin(th2)                ...
    + l1*l2*m3*thdot3^2*sin(th2)                ...
    - l1*lc2*m2*thdot2^2*sin(th2)               ...
    - 2*l2*lc3*m3*thdot3^2*sin(th3)             ...
    - l2*lc3*m3*thdot1^2*sin(2*th2 + th3)       ...
    - 2*l1*lc3*m3*thdot2*thdot3*sin(th2 + th3)  ...
    - 2*l2*lc3*m3*thdot2*thdot3*sin(th3)        ...
    ;...
      I_xy_3*thdot1^2*cos(2*th2 + 2*th3)        ...
    + (I_xx_3*thdot1^2*sin(2*th2 + 2*th3))/2    ...
    - (I_yy_3*thdot1^2*sin(2*th2 + 2*th3))/2    ...
    - (lc3^2*m3*thdot1^2*sin(2*th2 + 2*th3))/2  ... 
    - l1*lc3*m3*thdot2^2*sin(th2 + th3)         ...
    - l1*lc3*m3*thdot3^2*sin(th2 + th3)         ...
    - 2*l1*l2*m3*thdot2^2*sin(th2)              ...
    + (l2*lc3*m3*thdot1^2*sin(th3))/2           ...
    + l2*lc3*m3*thdot2^2*sin(th3)               ...
    - l2*lc3*m3*thdot3^2*sin(th3)               ...
    - (l2*lc3*m3*thdot1^2*sin(2*th2 + th3))/2   ...
    - 2*l1*lc3*m3*thdot2*thdot3*sin(th2 + th3)  ...
    - 2*l1*l2*m3*thdot2*thdot3*sin(th2)
]

GravityVector =[
    0;
    g*lc3*m3*sin(th2 + th3) + g*l2*m3*sin(th2) + g*lc2*m2*sin(th2);
    g*lc3*m3*sin(th2 + th3) 
]

%% Statespace equation
jointAngleAccVector = [
    thdotdot1;
    thdotdot2;
    thdotdot3
];

%Inverse Dynamics Equation
tauVector = MassMatrix*jointAngleAccVector+VelocityVector+GravityVector

%Forward Dynamics Equation
jointAngleAccVector = inv(MassMatrix)*(tauVector-(VelocityVector)+GravityVector)





