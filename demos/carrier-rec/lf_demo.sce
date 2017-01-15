// Description
// Demonstration for first / second order loop filter
// Authors
//  J.A., full documentation available on www.tsdconseil.fr/log/sct

cdir = get_absolute_file_path("soopll_demo.sce");


pnames = ['Normalized loop bandwidth (0 < BL < 0.5)';'Damping factor';'Phase noise level (linear) [radians]';'Number of samples (test duration)'];
pdef = ['0.1';'0.5';'0.05';'100'];
choix = x_mdialog('Second order loop filter demo', pnames, pdef);

if length(choix) == 0 then
    abort;
end

BL  = evstr(choix(1));
eta = evstr(choix(2));
nl  = evstr(choix(3));
n   = evstr(choix(4));

printf("BL = %f, eta = %f.\n", BL, eta);

nl = 0;

function [vt,vn,pe] = mytest(vref,name,fnum)
    
  so = lf_init(2, BL, eta);
  //so.rho = 0;
  if(fnum == 1)
    disp(so);
  end;
  n = length(vref);
  vt = zeros(n,1);
  pe = vt;
  theta = 0;
  for i = 1:n
    ped = vref(i) - theta;
    ped = ped + nl*rand(1,1,'n');
    pe(i) = ped;
    [so,theta] = so.process(so,ped);
    vt(i) = theta;
    vn(i) = so.mu;
  end
  
  subplot(3,2,fnum);
  plot(vref,'g-');
  plot(vt,'b-');
  plot(pe,'r-');
  xtitle(name, 'Samples', 'Phase (radians)');
  legend(['Reference phase';'Detected phase';'Phase error detector (ped)']);
  a = gca();
  a.title.font_size = 3;
  subplot(3,2,fnum+1);
  plot(diff(vref),'g-');
  plot(vn,'b-');
  plot(diff(vref)-vn(2:$),'r-');
  xtitle(name, 'Samples', 'Frequency (radians/sample)');
  legend(['Reference freq.';'Estimated freq.';'Error']);
  a = gca();
  a.title.font_size = 3;
endfunction


clf();
v0 = zeros(n/4,1);
vref = [v0 ; %pi/2 * ones(n,1)];
[vt,vn,pe] = mytest(vref,'Tracking fixed phase offset (no frequency offset)',1);

vref = [v0 ; (0:n-1)' * BL*2];// / 2;
[vt,vn,pe] = mytest(vref,'Tracking fixed frequency offset',3);

vref = [v0 ; %pi/4 * sin((0:n-1)' * 2 * %pi * BL / 8)];
[vt,vn,pe] = mytest(vref,'Tracking oscillatory frequency offset (freq = BL/8)',5);

