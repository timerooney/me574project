close all
clear all
clc

s = tf('s');
Gp = (6*s+600)/(20*s^2+240*s+2000)
Hy = 1


% respuesta Correcta
TFcontroller = tf([0.5593 91.1 677.9 1561 975.4],[0.0001188 0.04871 3.82 14.62 1]) %TfC1*TfC2


%   0.5593 s^4 + 91.1 s^3 + 677.9 s^2 + 1561 s + 975.4
%   ----------------------------------------------------
%   0.0001188 s^4 + 0.04871 s^3 + 3.82 s^2 + 14.62 s + 1


Try = feedback(Gp*TFcontroller,Hy)
Tru = feedback(TFcontroller,Gp)%to get Upeak
Tdy = feedback(Gp,-TFcontroller*Hy)%to get Edist Disturbance Rejection
Tre = feedback(1,Gp*TFcontroller*Hy)
ST = stepinfo(Try)


figure(1)
%subplot(1,3,1)
step(Try)
Y = step(Try);
Y2= Y(end)/4;
x2= 0;%ST.SettlingTime*(1/100);%0.01;
sep = 27/100;
Wt = 5;
dx = 0.01;%ST.SettlingTime*(1/100);
[EtrackMag,EtrackPhase] = bode(Tre,Wt);
text(x2,Y2*(1+sep),sprintf('Tr = %3.4f', ST.RiseTime))
text(x2,Y2,sprintf('PO = %3.4f', ST.Overshoot))% adding the Data to the plot
text(x2,Y2*(1-sep),sprintf('Wb = %3.4f', bandwidth(Try)))
text(x2,Y2*(1-2*sep),sprintf('Edist = %3.4f', bode(Tdy,0.3)))
text(x2,Y2*(1-3*sep),sprintf('Upeak = %3.4f', max(step(Tru))))
text(x2+dx,Y2*(1+sep),sprintf('Ts = %3.4f', ST.SettlingTime))
text(x2+dx,Y2,sprintf('SSE = %3.4f', 1-Y(end)))
text(x2+dx,Y2*(1-sep),sprintf('Etrack = %3.4f', EtrackMag))
title('Step Try - from my program')
grid on


%==========================================================================

Gc1N = [0.7968 0.8];
Gc1D = [0.01004 1];

Gc11N = [0.2689 0.9];
Gc11D = [0.003263 1];

GC1 = tf(Gc1N,Gc1D) 
GC11 = tf(Gc11N,Gc11D)

TfGC1 = GC1*GC11


Gc2N = [11.48 38.4];
Gc2D = [14.35 1];

Gc22N = [0.2273 35.28];
Gc22D = [0.2526 1];

GC2 = tf(Gc2N,Gc2D) 
GC22 = tf(Gc22N,Gc22D)

TfGC2 = GC2*GC22

TFcontroller = TfGC1*TfGC2

Try = feedback(Gp*TFcontroller,Hy)
Tru = feedback(TFcontroller,Gp)%to get Upeak
Tdy = feedback(Gp,-TFcontroller*Hy)%to get Edist Disturbance Rejection
Tre = feedback(1,Gp*TFcontroller*Hy)
ST = stepinfo(Try)

figure(2)
%subplot(1,3,2)
step(Try)
Y = step(Try);
Y2= Y(end)/4;
x2= 0;%ST.SettlingTime*(1/100);%0.01;
sep = 27/100;
Wt = 5;
%ST.SettlingTime*(1/100);
[EtrackMag,EtrackPhase] = bode(Tre,Wt);
text(x2,Y2*(1+sep),sprintf('Tr = %3.4f', ST.RiseTime))
text(x2,Y2,sprintf('PO = %3.4f', ST.Overshoot))% adding the Data to the plot
text(x2,Y2*(1-sep),sprintf('Wb = %3.4f', bandwidth(Try)))
text(x2,Y2*(1-2*sep),sprintf('Edist = %3.4f', bode(Tdy,0.3)))
text(x2,Y2*(1-3*sep),sprintf('Upeak = %3.4f', max(step(Tru))))
text(x2+dx,Y2*(1+sep),sprintf('Ts = %3.4f', ST.SettlingTime))
text(x2+dx,Y2,sprintf('SSE = %3.4f', 1-Y(end)))
text(x2+dx,Y2*(1-sep),sprintf('Etrack = %3.4f', EtrackMag))
title('Step Try - the product')
grid on


%============================TIM===========================================


Nc1 = [0.5593, 91.1, 677.9, 1561, 975.4];
Dc1 = [0.0001188, 0.04871, 3.82, 14.62, 1];

TfTim = tf( Nc1 , Dc1)

TFcontroller = TfTim

Try = feedback(Gp*TFcontroller,Hy)
Tru = feedback(TFcontroller,Gp)%to get Upeak
Tdy = feedback(Gp,-TFcontroller*Hy)%to get Edist Disturbance Rejection
Tre = feedback(1,Gp*TFcontroller*Hy)
ST = stepinfo(Try)

figure(3)
%subplot(1,3,3)
step(Try)
Y = step(Try);
Y2= Y(end)/4;
x2= 0;%ST.SettlingTime*(1/100);%0.01;
sep = 27/100;
Wt = 5;
%ST.SettlingTime*(1/100);
[EtrackMag,EtrackPhase] = bode(Tre,Wt);
text(x2,Y2*(1+sep),sprintf('Tr = %3.4f', ST.RiseTime))
text(x2,Y2,sprintf('PO = %3.4f', ST.Overshoot))% adding the Data to the plot
text(x2,Y2*(1-sep),sprintf('Wb = %3.4f', bandwidth(Try)))
text(x2,Y2*(1-2*sep),sprintf('Edist = %3.4f', bode(Tdy,0.3)))
text(x2,Y2*(1-3*sep),sprintf('Upeak = %3.4f', max(step(Tru))))
text(x2+dx,Y2*(1+sep),sprintf('Ts = %3.4f', ST.SettlingTime))
text(x2+dx,Y2,sprintf('SSE = %3.4f', 1-Y(end)))
text(x2+dx,Y2*(1-sep),sprintf('Etrack = %3.4f', EtrackMag))
title('Step Try - TIM')
grid on

% Not good
% KBode = bode(TFcontroller*Gp*Hy, 0)
% SSEstep = 1/(1+KBode)

ee = step(Tre);
Ess = ee(end)











