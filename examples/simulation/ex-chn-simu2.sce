
prm = chn_simu_prm();
// Add white noise
prm.sigma_wn = .1;
mod = mod_init('qpsk',fs=1e6,fi=100e3,fsymb=10e3,'c');
[mod,x] = mod_process(mod,prbs(nsymb=100));

scf(0); clf();
subplot(121); plot_const(x); xtitle("Before channel");

x = chn_simu(x,prm);

subplot(122); plot_const(x); xtitle("After channel");

ccdir = get_absolute_file_path("ex-chn-simu2.sce");
xs2png(gcf(),ccdir+ '../../help/en_US/simulation/ex-chn-simu2.png');


//prm = chn_simu_prm();
//// Add white noise
//prm.sigma_wn = .1;
//mod = mod_init('qpsk',fs=1e6,fi=400e3,fsymb=100e3,'r');
//[mod,x] = mod_process(mod,prbs(10));
//
//scf(0); clf();
//subplot(211); plot(x); xtitle("Before channel");
//
//x = chn_simu(x,prm);
//
//subplot(212); plot(x); xtitle("After channel");
//
//ccdir = get_absolute_file_path("ex-chn-simu2.sce");
//xs2png(gcf(),ccdir+ '../../help/en_US/simulation/ex-chn-simu2.png');
//
