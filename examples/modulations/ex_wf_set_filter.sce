
wf = wf_init('qpsk');
wf = wf_set_filter(wf, 'srrc', 50, 0.2);
mod = mod_init(wf,10,0,1);
[mod,x] = mod_process(mod,prbs(1000));
clf(); plot_const(x);

xs2png(gcf(),'c:/dev/formations/sdr/comm-tbx-doc/ug/img/wf-filter1.png');
