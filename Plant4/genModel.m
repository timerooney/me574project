function [Fcl, Gcl, Hcl, Jcl, Nf, K, Gp] = genModel( q1, q2, q3, r1 )
%GENMODEL Summary of this function goes here
%   Detailed explanation goes here
    Fp = [-0.3, 0, -0.01;
          1, 0, 0;
          -1.3, 9.8, -0.02];
    Gp = [6.3; 0; 9.8];
    Hp = [0, 1, 0];
    Jp = 0;

    Q = genQ(q1, q2, q3);
    R = genR(r1);
    K = lqr(Fp, Gp, Q, R);

    Fcl = Fp - Gp*K;
    Hcl = Hp - Jp*K;

    Nf = 1/(Hcl*inv(-Fcl)*Gp + Jp);

    Gcl = Gp*Nf;
    Jcl = Jp*Nf;

end
