close all
clear all
clc

s = tf('s');
Gp = (6*s+6000)/(20*s^2+240*s+2000)
Hy = 1


% respuesta Correcta
TFcontroller = tf([2.379 18.48 30.72],[0.1041 8.976 1]) %TfC1*TfC2


%   2.379 s^2 + 18.48 s + 30.72
%   ---------------------------
%    0.1041 s^2 + 8.976 s + 1


Try = feedback(Gp*TFcontroller,Hy)
Tru = feedback(TFcontroller,Gp)%to get Upeak
Tdy = feedback(Gp,-TFcontroller*Hy)%to get Edist Disturbance Rejection
Tre = feedback(1,Gp*TFcontroller*Hy)
ST = stepinfo(Try)


figure(1)
subplot(1,3,1)
step(Try)
Y = step(Try);
Y2= Y(end)/4;
x2= 0.1;
sep = 27/100;
text(x2,Y2*(1+sep),sprintf('Tr = %3.4f', ST.RiseTime))
text(x2,Y2,sprintf('PO = %3.4f', ST.Overshoot))% adding the Data to the plot
text(x2,Y2*(1-sep),sprintf('Wb = %3.4f', bandwidth(Try)))
text(x2,Y2*(1-2*sep),sprintf('Edist = %3.4f', bode(Tdy,0.3)))
text(x2,Y2*(1-3*sep),sprintf('Upeak = %3.4f', max(step(Tru))))
text(x2+1,Y2*(1+sep),sprintf('Ts = %3.4f', ST.SettlingTime))
text(x2+1,Y2,sprintf('SSE = %3.4f', 1-Y(end)))
%text(x2+1,Y2*(1-sep),sprintf('Wb = %3.4f', bandwidth(Try)))
title('Step Try - from my program')
grid on


%==========================================================================

Gc1N = [0.3317 0.8];
Gc1D = [0.01161 1];
TfC1 = tf(Gc1N,Gc1D)

Gc2N = [7.1171 38.4];
Gc2D = [8.964 1];
TfC2 = tf([7.1171 38.4] , [8.964 1])

TFcontroller = TfC1*TfC2

Try = feedback(Gp*TFcontroller,Hy)
Tru = feedback(TFcontroller,Gp)%to get Upeak
Tdy = feedback(Gp,-TFcontroller*Hy)%to get Edist Disturbance Rejection
Tre = feedback(1,Gp*TFcontroller*Hy)
ST = stepinfo(Try)

subplot(1,3,2)
step(Try)
Y = step(Try);
Y2= Y(end)/4;
x2= 0.1;
sep = 27/100;
text(x2,Y2*(1+sep),sprintf('Tr = %3.4f', ST.RiseTime))
text(x2,Y2,sprintf('PO = %3.4f', ST.Overshoot))% adding the Data to the plot
text(x2,Y2*(1-sep),sprintf('Wb = %3.4f', bandwidth(Try)))
text(x2,Y2*(1-2*sep),sprintf('Edist = %3.4f', bode(Tdy,0.3)))
text(x2,Y2*(1-3*sep),sprintf('Upeak = %3.4f', max(step(Tru))))
text(x2+1,Y2*(1+sep),sprintf('Ts = %3.4f', ST.SettlingTime))
text(x2+1,Y2,sprintf('SSE = %3.4f', 1-Y(end)))
%text(x2+1,Y2*(1-sep),sprintf('Wb = %3.4f', bandwidth(Try)))
title('Step Try - the product')
grid on


%============================TIM===========================================
Nc1 = [2.379 18.48 30.72]
Dc1 = [0.1041 8.976 1]

% Nc1 = [2.379, 16.09, 24.96]
% Dc1 = [0.1041, 8.976, 1]

TfTim = tf( Nc1 , Dc1)

TFcontroller = TfTim

Try = feedback(Gp*TFcontroller,Hy)
Tru = feedback(TFcontroller,Gp)%to get Upeak
Tdy = feedback(Gp,-TFcontroller*Hy)%to get Edist Disturbance Rejection
Tre = feedback(1,Gp*TFcontroller*Hy)
ST = stepinfo(Try)

subplot(1,3,3)
step(Try)
Y = step(Try);
Y2= Y(end)/4;
x2= 0.1;
sep = 27/100;
text(x2,Y2*(1+sep),sprintf('Tr = %3.4f', ST.RiseTime))
text(x2,Y2,sprintf('PO = %3.4f', ST.Overshoot))% adding the Data to the plot
text(x2,Y2*(1-sep),sprintf('Wb = %3.4f', bandwidth(Try)))
text(x2,Y2*(1-2*sep),sprintf('Edist = %3.4f', bode(Tdy,0.3)))
text(x2,Y2*(1-3*sep),sprintf('Upeak = %3.4f', max(step(Tru))))
text(x2+1,Y2*(1+sep),sprintf('Ts = %3.4f', ST.SettlingTime))
text(x2+1,Y2,sprintf('SSE = %3.4f', 1-Y(end)))
%text(x2+1,Y2*(1-sep),sprintf('Wb = %3.4f', bandwidth(Try)))
title('Step Try - TIM')
grid on















