BL = 0.1;
eta = 0.5;

so = sopll_init(BL, eta);
n = 4 * 1 / BL;
theta = 0;
for i = 1:n
    ped = %pi/2 - theta;
    [so,theta] = sopll_process(so,ped);
end

assert_checkalmostequal(theta,%pi/2,0.05);


