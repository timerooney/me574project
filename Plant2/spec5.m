%%% Spec 5

%% Define the system
Gp = tf([6, 600], [20, 240, 2000, 0]);


%% See the uncompensated performance characteristics
Gol_u = Gp;
Gcl_u = feedback(Gp, 1);

[~, PM, ~, ~] = margin(Gol_u)

s = tf('s');
e_ss_ramp = abs((1 - dcgain(Gcl_u/s))/1)

wt = 10;
Tre = feedback(1, Gp);
[tracking_error, ~, ~] = bode(Tre, wt);
tracking_error = tracking_error*100

% There are some accuracy issues
% Some PM can be afforded and accuracy is needed, so try phase-lag

%% Phase-lag initial design

% We'll have a phase-margin of just over 60 deg if wpm is 4.2rad/s, we need
% to find the gain increase that gives this
mag_un = bode(Gol_u, 4.2)
Kc = 1/mag_un

% Determine alpha
track_gain_unkc = bode(feedback(1, Kc*Gp), 10)
% We need a gain of at least 2000 at wt=10 to hit the tracking accuracy
% requirements. It is currently 0.0251, so increase gain by
alpha_min = 2000/track_gain_unkc
% Let's use 2e3
alpha = 2e3

% Determine corner frequency
[~, ~, ~, wc_unkc] = margin(Kc*Gol_u)
% wc_unkc = initial wpm as expected
wcorner = wc_unkc / 5
tau = 1/wcorner

%% Phase-lag implementation
Gc = alpha*tf([tau, 1], [alpha*tau, 1]) % Need to make type 1 system
Kc = Kc; % Needed for stability

Gcl = feedback(Kc*Gc*Gp, 1);
Gol = Kc*Gc*Gp;

[~, PM, ~, ~] = margin(Gol)

Kbode = bode(Gol, eps);
e_ss_ramp = 100/Kbode

wt = 10;
Tre = feedback(1, Kc*Gc*Gp);
[tracking_error, ~, ~] = bode(Tre, wt);
tracking_error = tracking_error*100

% Get performance

% Phase-lag has too much loss in accuracy, try PID now

%% PID initial design
% Plot uncomponsated system
margin(1000*tf([1, 1, 1], 1)*Gp); % We know right away that an extra zero will be needed

Gol = 1000*tf([1, 1, 1], 1)*Gp;
Gcl = feedback(Gol, 1);

[~, PM, ~, ~] = margin(Gol)

kbode = bode(Gol, eps);
e_ss_ramp = 100/kbode

wt = 10;
Tre = feedback(1, Gol);
[tracking_error, ~, ~] = bode(Tre, wt);
tracking_error = tracking_error*100


%% Answer
% System passes

Ts5=NaN;
Nf5=NaN;
K5=NaN;
Nc5 = [1000, 1000, 1000]
Dc5 = [1]
