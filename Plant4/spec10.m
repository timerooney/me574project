% Modifiables
q1 = 10000;
q2 = 10000000;
q3 = 0.1;
r1 = 90;

[Fcl, Gcl, Hcl, Jcl, Nf, K, Gp] = genModel(q1, q2, q3, r1);

modelPerformance(Fcl, Gcl, Hcl, Jcl, Nf, K, Gp);
