Gp = tf([10*2, 10*1600], [1, 350-200, 350*-200])

Nc = [2720 -2720];
Dc = [1 -1];


Gc = tf(Nc, Dc)


% Convert to discrete
% First guestimate for wb
bwidth = bandwidth(feedback(Gp, Gc)) / (2*pi)