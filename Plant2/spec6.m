% Spec 6

%% Define system
Gp = tf([6, 600], [20, 240, 2000, 0]);

%% Find initial performance characteristics
Gol_un = Gp;
Gcl_un = feedback(Gp, 1);

wb = bandwidth(Gcl_un)
info = stepinfo(Gcl_un);
tr = info.RiseTime
PO = info.Overshoot

Tru = feedback(1, Gp);
Upeak = max(step(Tru))

Ts = info.SettlingTime;
Dt = (5*Ts)/1000;
tt = 0:Dt:(5*Ts);
y = step(Gcl_un, tt);
Yss = bode(Gcl_un, 0);

IAE = sum(abs(y-Yss)*Dt)


% Need to do:
% Increase bandwidth from 0.3 to 10
% Lower tr from 7 to 0.5
% Keep no PO
% Get IAE below 0.5
% Keep Upeak under 1000

%% Attempt PID
wc_min = 10/sqrt(2);
wc = wc_min*1.5

wz = wc/5;

tau_d = 1/wz;
tau_i = 1/wz;

Gc_nokp = tf([tau_d, 1+tau_d/tau_i, 1/tau_i], [1, 0]);

bode(Gc_nokp*Gp)
% Crossover frequency is around 0.85
mag_wc = bode(Gc_nokp*Gp, wc)
% Multiply to move wc to get desired bandwidth, plus a little buffer
kp = 1.25/mag_wc

Gc = Gc_nokp*kp;

%% Measure performance of PID controller and adjust
kp = kp*1;
tau_d = tau_d*1;
tau_i = tau_i*1000;

Gc = kp*tf([tau_d, 1+tau_d/tau_i, 1/tau_i], [1, 0]) * tf(1, [0.01, 1]);

Gol = Gc*Gp;
Gcl = feedback(Gc*Gp, 1);

wb = bandwidth(Gcl)
info = stepinfo(Gcl);
tr = info.RiseTime
PO = info.Overshoot


Tru = feedback(Gc, Gp);
Upeak = max(step(Tru))

Ts = info.SettlingTime;
Dt = (5*Ts)/1000;
tt = 0:Dt:(5*Ts);
y = step(Gcl, tt);
Yss = bode(Gcl, 0);

IAE = sum(abs(y-Yss)*Dt)

% It passes

%% Create answer
Ts6=NaN;
Nf6=NaN;
K6=NaN;
Nc6 = [5.0953, 10.8195, 0.02293]
Dc6 = [0.01, 1, 0]

%% Convert to discrete
% Find initial guess at Fs and Ts
bwidth = bandwidth(Gcl);
Fs = bwidth*25;
Fs = 125
Ts = 1/Fs;

Gc_z = c2d(Gc, Ts, 'tustin');
Gp_z = c2d(Gp, Ts, 'zoh');
Gol_z = Gp_z*Gc_z;
Try_z = feedback(Gc_z*Gp_z, 1);
%%%% Check the bandwidth
ClWb = (bandwidth(Try_z) / (2*pi))
Fs_max = ClWb*50

Fs