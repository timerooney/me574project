% Plant 1 - Specification 4 Design
%% System Definitions

Gp = tf([6, 600], [20, 240, 2000]);
Hy = 1;


%% First, design through normal continuous methods

%%% Initial test - see how uncompensated system performs
Gol_u = Gp;
Gcl_u = feedback(100*Gp, Hy);

%figure
subplot(2,1,1)
margin(Gol_u)
subplot(2,1,2)
step(Gcl_u)

%%%% Get performance measures
verifier(Gp, 1, 1, Hy);

%%%% Output
% Phase margin: Inf
% Gain margin: Inf
% Crossover frequency: NaN
% Bandwidth: 14.047161
% Percent overshoot: 13.457347
% Rise time: 0.149452
% Settling time: 0.498646
% Steady state error - step: 76.923077%
% Steady state error - ramp: Inf%
% Tracking accuracy: 78.930705%
% Noise rejection: 7.562614e-02
% Disturbance rejection: 4.285852e-01
% Max control effort: 1.000000
% ISE: 0.045382

%%%% Need keep in mind the following
% I think that the solution method for this system is to damp as much as possible while keeping Upeak low
%%%% Adjust the following
Kc = 1;
alpha = 10;
tau = 1/(10*sqrt(alpha));

%%%% Show performance of continuous time system
Gc = Kc * tf([tau, 1], [alpha*tau, 1]);

Try = feedback(Gp*Gc, Hy);
info = stepinfo(Try);
risetime = info.RiseTime
settlingtime = info.SettlingTime
PO = info.Overshoot

ws = 377;
Tvy = feedback(-Hy*Gc*Gp, 1);
Ngain = bode(Tvy, ws)

Tru = feedback(Gc, Gp*Hy);
Upeak = max(step(Tru))


%%% Convert to discrete since the above parameters pass
% Figure out initial bandwidth to initialize Fs
init_bandwidth = bandwidth(Try)
% Let's initalize it at 150
Fs = 30;
Ts = 1/Fs;

Gc_z = c2d(Gc, Ts, 'tustin');
Gp_z = c2d(Gp, Ts, 'zoh');
Try_z = feedback(Gp_z*Gc_z, 1);

%%%% Performance parameters
info = stepinfo(Try_z);
risetime = info.RiseTime
settlingtime = info.SettlingTime
PO = info.Overshoot

ws = 377;
Tvy_z = feedback(-Gc_z*Gp_z, 1);
Ngain = bode(Tvy_z, ws)

Tru_z = feedback(Gc_z, Gp_z);
Upeak = max(step(Tru_z))

%%%% Verify frequency still passes
ClWb = (bandwidth(Try_z) / (2*pi))
Fs_max = ClWb*50
Fs

%%% As expected, the discrete-time system is slightly less damped than the continuous time one, but there was enough buffer given that it still passes

%%% Information for project file
Ts4=Ts
Nf4=NaN;
K4=NaN;
[Nc4, Dc4] = tfdata(Try_z, 'v')
