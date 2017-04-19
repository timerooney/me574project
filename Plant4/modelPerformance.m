function modelPerformance( Fcl, Gcl, Hcl, Jcl, Nf, K, Gp )
%MODELPERFORMANCE Summary of this function goes here
%   Detailed explanation goes here

    % Basic performance values
    SSry = ss(Fcl, Gcl, Hcl, Jcl);
    wb = bandwidth(SSry);
    fprintf('wb: %f\n', wb);
    information = stepinfo(SSry);
    ts = information.SettlingTime;
    fprintf('ts: %f\n', ts);
    tr = information.RiseTime;
    fprintf('tr: %f\n', tr);
    PO = information.Overshoot;
    fprintf('PO: %f\n', PO);
    SSE = dcgain(SSry) - 1.0;
    fprintf('SSE: %f\n', SSE);

    % Etrack
    SSre = ss(Fcl, Gcl, -Hcl, 1-Jcl);
    wt = 2;
    [Etrack, ~, ~] = bode(SSre, wt);
    Etrack = Etrack * 100;
    fprintf('Etrack: %f\n', Etrack);

    % Edist
    SSdy = ss(Fcl, Gp, Hcl, Jcl);
    wd = 6;
    [Edist, ~, ~] = bode(SSdy, wd);
    fprintf('Edist: %f\n', Edist);

    % Upeak
    SSru = ss(Fcl, Gcl, -K, Nf);
    Upeak = max(step(SSru));
    fprintf('Upeak: %f\n', Upeak);

    % ISE
    SSre = ss(Fcl, Gcl, -Hcl, 1-Jcl);
    [y_stepe, t_stepe] = step(SSre);
    ISE = trapz(t_stepe, y_stepe.^2);
    fprintf('ISE: %f\n', ISE);


end
