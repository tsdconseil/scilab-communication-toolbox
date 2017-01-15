

// 
mod = mod_init('msk',fs=0.5e6,fi=100e3,fsymb=20e3);
[mod,x] = mod_process(mod,prbs(2000));
clf(); plot_psd(x);

xs2png(gcf(), 'c:/dev/formations/sdr/comm-tbx-doc/ug/img/mod1.png');
