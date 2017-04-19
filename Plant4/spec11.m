% The requirements are close to spec10, so we can use that as a starting
% point

% Everything passes except tracking error needs to be about 10x lower.
% Luckily we have a lot of control effort to play with

% Modifiables
q1 = 1;
q2 = 10000000000;
q3 = 1;
r1 = 400;

[Fcl, Gcl, Hcl, Jcl, Nf, K, Gp] = genModel(q1, q2, q3, r1);

modelPerformance(Fcl, Gcl, Hcl, Jcl, Nf, K, Gp);

% I'm getting stuck getting Etrack below 1%