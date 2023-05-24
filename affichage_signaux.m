close all;
clc;


[sl, y] = func_ASK(100e3, 1000, 10e-3, 100e-3, 1.5e3, "porte", 50);
    
fe = 100e3;
N = 1000;

figure;
subplot(2,1,1);
plot((0:N-1)/fe, sl(1:N),'LineWidth', 2,'Color','black');
xlabel('Temps (en s)');
ylabel('Amplitude');
ylim([-0.1 1.1]);
title("S\'{e}quence binaire");
grid on;

subplot(2,1,2);
plot((0:N-1)/fe, real(y(1:N)),'LineWidth', 2,'Color','black');
xlabel('Temps (en s)');
ylabel('Amplitude');
ylim([-1.1 1.1]);
title("Partie r\'{e}elle de l'enveloppe complexe");
grid on;

[sl2, y2] = func_FSK(100e3, 1000, 10e-3, 100e-3, 1000, 3000,"porte", 50);

N = 1000;

figure(2);
subplot(2,1,1);
plot((0:N-1)/fe, sl2(1:N),'LineWidth', 2,'Color','black');
xlabel('Temps (en s)');
ylabel('Amplitude');
ylim([-0.1 1.1]);
title("S\'{e}quence binaire");
grid on;

subplot(2,1,2);
plot((0:N-1)/fe, real(y2(1:N)),'LineWidth', 2,'Color','black');
xlabel('Temps (en s)');
ylabel('Amplitude');
ylim([-1.1 1.1]);
title("Partie r\'{e}elle de l'enveloppe complexe");
grid on;


M = 4;
[sl3, y3] = func_MPSK(100e3, 1000, 10e-3, 100e-3, 1000, M,"porte", 50);

N = 1000;

figure(3);
subplot(2,1,1);
plot((0:N*log2(M)-1)/fe, sl3(1:N*log2(M)),'LineWidth', 2,'Color','black');
xlabel('Temps (en s)');
ylabel('Amplitude');
ylim([-0.1 1.1]);
title("S\'{e}quence binaire");
grid on;

subplot(2,1,2);
plot((0:N-1)/fe, real(y3(1:N)),'LineWidth', 2,'Color','black');
xlabel('Temps (en s)');
ylabel('Amplitude');
ylim([-1.1 1.1]);
title("Partie r\'{e}elle de l'enveloppe complexe");
grid on;

M = 4;
[sl4, y4] = func_MQAM(100e3, 1000, 10e-3, 100e-3, 1000, M,"porte", 50);

N = 1000;

figure(4);
subplot(2,1,1);
plot((0:N*log2(M)-1)/fe, sl4(1:N*log2(M)),'LineWidth', 2,'Color','black');
xlabel('Temps (en s)');
ylabel('Amplitude');
ylim([-0.1 1.1]);
title("S\'{e}quence binaire");
grid on;

subplot(2,1,2);
plot((0:N-1)/fe, real(y4(1:N)),'LineWidth', 2,'Color','black');
xlabel('Temps (en s)');
ylabel('Amplitude');
ylim([-(M-1)/2 (M-1)/2]);
title("Partie r\'{e}elle de l'enveloppe complexe");
grid on;
