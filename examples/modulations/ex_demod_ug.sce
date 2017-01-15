
[x,fs,fi,fsymb,b] = sct_test_signal();
wf = wf_init('bpsk');
demod = demod_init(wf,fs,fi,fsymb);
[demod,b2] = demod_process(demod,x);
clf(); 
subplot(211); plot_binary(b);
subplot(212); plot_binary(b2);
xs2png(gcf(), 'c:/dev/formations/sdr/comm-tbx-doc/ug/img/demod1.png');
