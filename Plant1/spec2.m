% Plant 1 - Specification 2 Design
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

%%%% Need the following
% Higher bandwidth
% Lower settling time
% Lower percent overshoot
% Lower tracking error
% Lower ISE
%
% This summarizes to needing higher accuracy and higher speed, so we can try a PID controller


%%% Implement PID controller
%%%% Determine closed-loop bandwidth
wb_min = 100;
wc_min = wb_min/sqrt(2)
% Add more to wc since we need extra damping once we switch to discrete time anyway
wc = wc_min*1.5
%%%% Approximate wz, tau_d, and tau_i
wz = wc/5
tau_d = 1/wz
tau_i = 1/wz
% Find kp based on what is needed to hit wc
Gc_nokp = tf([tau_d, 1+tau_d/tau_i, 1/tau_i], [1, 0])
Gol_nokp = Gp*Gc_nokp
[mag, ~, ~] = bode(Gol_nokp, wc)
mag_db = 20*log10(mag)
% kp needs to increase magnitude by 33.956dB
kp = 1/mag
% Add an additional pole for realizable form
Gc = Gc_nokp * tf([1], [0.01, 1]);

%%%% Test system
verifier(Gp, kp, Gc, Hy);

%%%% Adjust until values pass
kp = 50
tau_d = 0.0471*10
tau_i = tau_d
Gc_nokp = tf([tau_d, 1+tau_d/tau_i, 1/tau_i], [1, 0])
Gc = Gc_nokp * tf([1], [0.01, 1]);

verifier(Gp, kp, Gc, Hy);


%%% The above parameters pass, convert to discrete time
%%%% Let's start out with an Fs of 1500
Fs = 5000;
Ts = 1/Fs;

Gc_z = c2d(kp*Gc, Ts, 'tustin');
Gp_z = c2d(Gp, Ts, 'zoh');
Try_z = feedback(Gp_z*Gc_z, 1);
Gol_z = Gp_z*Gc_z;
%%%% Check the bandwidth
ClWb = (bandwidth(Try_z) / (2*pi))
Fs_max = ClWb*50
Fs

%%% Verify controller passes
wb = ClWb

info = stepinfo(Try_z);
settlingtime = info.SettlingTime
PO = info.Overshoot

wt = 5.0;
Trez = feedback(1, Gc_z*Gp_z);
tracking_error = bode(Trez, wt)*100

[y_stepe, t_stepe] = step(Try_z);
ISE = trapz(t_stepe, y_stepe.^2)

%%% Information for project file
Ts2=Ts
Nf2=NaN;
K2=NaN;
[Nc2, Dc2] = tfdata(Try_z, 'v')
