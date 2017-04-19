function verifier(G_p, K_c, G_c, H_y)
    % Define the models
    G_ol = K_c*G_c*G_p*H_y;
    G_cl = feedback(K_c*G_c*G_p, H_y);


    % Performance Measures

    % Margins
    [Gm, Pm, ~, Wpm] = margin(G_ol);
    fprintf('Phase margin: %f\n', Pm);
    fprintf('Gain margin: %f\n', 20*log10(Gm));
    fprintf('Crossover frequency: %f\n', Wpm);

    % Bandwidth
    fprintf('Bandwidth: %f\n', bandwidth(G_cl));

    % Stepinfo
    step_info = stepinfo(G_cl);
    % Percent Overshoot
    po = step_info.Overshoot;
    fprintf('Percent overshoot: %f\n', po);

    % Rise time
    rise_time = step_info.RiseTime;
    fprintf('Rise time: %f\n', rise_time);

    % Settling time
    settling_time = step_info.SettlingTime;
    fprintf('Settling time: %f\n', settling_time);

    % Steady-state error for step input
    e_ss_step = abs((1 - dcgain(G_cl))/1);
    fprintf('Steady state error - step: %f%%\n', e_ss_step*100);

    % Steady-state error for ramp input
    s = tf('s');
    e_ss_ramp = abs((1 - dcgain(G_cl/s))/1);
    fprintf('Steady state error - ramp: %f%%\n', e_ss_ramp*100);

    % Tracking accuracy with wt = 5.0
    wt = 5.0;
    Tre = feedback(1, K_c*G_c*G_p*H_y);
    tracking_accuracy = abs(evalfr(Tre, j*wt));
    fprintf('Tracking accuracy: %f%%\n', tracking_accuracy*100);

    % Noise rejection at ws = 20
    ws = 20;
    Tvy = feedback(-H_y*K_c*G_c*G_p, 1);
    noise_rejection = abs(evalfr(Tvy, j*ws));
    fprintf('Noise rejection: %e\n', noise_rejection);
    
    % Disturbance rejection
    wd = 0.3;
    Tdy = feedback(G_p, -G_c*H_y);
    disturbance_rejection = abs(evalfr(Tdy, j*wd));
    fprintf('Disturbance rejection: %e\n', disturbance_rejection);

    % Peak control effort, Upeak
    Tru = feedback(K_c*G_c, G_p*H_y);
    U_peak = max(step(Tru));
    fprintf('Max control effort: %f\n', U_peak);
    
    [y_stepe, t_stepe] = step(G_cl);
    ISE = trapz(t_stepe, y_stepe.^2);
    fprintf('ISE: %f\n', ISE);
end
