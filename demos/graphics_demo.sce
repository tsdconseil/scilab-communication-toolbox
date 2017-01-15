// Description
// Demonstration for comm tbx graphics functions
// Authors
//  J.A., full documentation available on www.tsdconseil.fr/log/sct

// (1) Eye diagram
scf(0);
f = gcf();
clf();
f.figure_position = [0,0];
f.figure_size = [500,300];
//subplot(2,2,1);
osf = 128; nsymb = 500;
x = nrz(prbs(nsymb),osf);
x = awgn(ma(x, osf), 0.1);
plot_eye(x, osf);

// (2) Constellation plot
scf(1);
f = gcf();
clf();
f.figure_position = [500,0];
f.figure_size = [300,300];
//subplot(2,2,2);
wf = wf_init('psk',8);
b = prbs(100000);
x = wf.modul(b);
x = awgn(x,0.2);
plot_const(x);
//xset("colormap",jetcolormap(512));
//xtitle(wf.name,'I','Q');

// (3) PSD plot
//subplot(2,2,3);
scf(2);
f = gcf();
clf();
f.figure_position = [0,350];
f.figure_size = [500,300];
fs = 48e3;
f = 12e3;
t = linspace(0,1,fs);
x = sin(2*%pi*f*t);
plot_psd(x,fs);

// (3) BER plot
//subplot(2,2,3);

// (4) S-curve
//subplot(2,2,4);

