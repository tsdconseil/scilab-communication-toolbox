


ovs = 4;
pat = nrz(ts01(16),ovs);
x = [rand(40,1,'n'); pat; rand(40,1,'n')];
scf(0); clf();
subplot(211);
plot(x);
n = length(x);
y = convol(x, pat);
xtitle("Signal reçu");
a = gca(); a.title.font_size = 3;
subplot(212);
plot(y(1:n));
xtitle("Corrélation avec l''en-tête (ici 010101...)");
a = gca(); a.title.font_size = 3;

xs2pdf(gcf(), 'c:/dev/formations/sdr/presentation/calage/01.pdf');


ovs = 4;
pat = nrz(prbs(16),ovs);
x = [rand(40,1,'n'); pat; rand(40,1,'n')];
scf(1); clf();
subplot(211);
plot(x);
n = length(x);
y = convol(x, pat);
subplot(212);
plot(y(1:n));


