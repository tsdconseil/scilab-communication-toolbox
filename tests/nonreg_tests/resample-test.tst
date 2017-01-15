t = (0:0.1:1)';
t2 = resample(t, 10.0);
// Trunk the end of interpolated signals
t2 = t2(1:101);
tref = (0:0.01:1)';
assert_checkalmostequal(max(t2-tref),0,1e-1,1e-2);
