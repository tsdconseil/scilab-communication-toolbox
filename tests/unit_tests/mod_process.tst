fs      = 1e3; 
fi      = 200;
fsymb   = 100;
wf = wf_init('bpsk');
mod = mod_init(wf,fs,fi,fsymb);
[mod,x] = mod_process(mod, prbs(10));
x = real(x);
assert_checkequal(length(x),100);
assert_checktrue(isreal(x));


fs      = 1e3; 
fi      = 0;
fsymb   = 100;
wf = wf_init('qpsk');
mod = mod_init(wf,fs,fi,fsymb);
[mod,x] = mod_process(mod, prbs(10));
assert_checkequal(length(x),50);
assert_checkfalse(isreal(x));

