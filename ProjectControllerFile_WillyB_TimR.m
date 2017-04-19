%% Name:WillyB_TimR
EmailAddress1='wesedano@uwm.edu'
EmailAddress2='terooney@uwm.edu'

%spec1      %% Continuous TF Compensator
Ts1=NaN;
Nf1=NaN;
K1=NaN;
Nc1 = 4*[0.4758, 7.194, 24.96]
Dc1 = [0.1041, 4.035, 1]


%spec3     %% Continuous TF Compensator
Ts3=NaN;
Nf3=NaN;
K3=NaN;
Nc3 = 400*[0.006253, 1.1856, 35.6358, 353.9052, 975.4214]
Dc3 = [0.0005312, 0.0505, 1.0173, 3.5216, 1]


%spec10    %% State-feedback model
Ts10 = NaN;
Nf10 = 341.3585;
K10 = [14.6755, 333.3379, 0.0021];
Nc10 = NaN;
Dc10 = NaN;

%spec12
Ts3=0.000001;
Nf3=NaN;
K3=NaN;
Nc3 = [2243 -2243]
Dc3 = [1 -1]

%spec13
Ts3=0.000001;
Nf3=NaN;
K3=NaN;
Nc3 = [2243 -2243]
Dc3 = [1 -1]

