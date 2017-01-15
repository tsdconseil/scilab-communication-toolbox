// Scilab Communication Toolbox
// (C) J.A. / contact: http://www.tsdconseil.fr 
//
// Ce logiciel est régi par la licence CeCILL-C soumise au droit français et
// respectant les principes de diffusion des logiciels libres. Vous pouvez
// utiliser, modifier et/ou redistribuer ce programme sous les conditions
// de la licence CeCILL-C telle que diffusée par le CEA, le CNRS et l'INRIA 
// sur le site "http://www.cecill.info".
//
// En contrepartie de l'accessibilité au code source et des droits de copie,
// de modification et de redistribution accordés par cette licence, il n'est
// offert aux utilisateurs qu'une garantie limitée.  Pour les mêmes raisons,
// seule une responsabilité restreinte pèse sur l'auteur du programme,  le
// titulaire des droits patrimoniaux et les concédants successifs.
//
// A cet égard  l'attention de l'utilisateur est attirée sur les risques
// associés au chargement,  à l'utilisation,  à la modification et/ou au
// développement et à la reproduction du logiciel par l'utilisateur étant 
// donné sa spécificité de logiciel libre, qui peut le rendre complexe à 
// manipuler et qui le réserve donc à des développeurs et des professionnels
// avertis possédant  des  connaissances  informatiques approfondies.  Les
// utilisateurs sont donc invités à charger  et  tester  l'adéquation  du
// logiciel à leurs besoins dans des conditions permettant d'assurer la
// sécurité de leurs systèmes et ou de leurs données et, plus généralement, 
// à l'utiliser et l'exploiter dans les mêmes conditions de sécurité. 
//
// Le fait que vous puissiez accéder à cet en-tête signifie que vous avez 
// pris connaissance de la licence CeCILL-C, et que vous en avez accepté les
// termes.

// Benchmarking of different phase error detectors


// Parameters: 
// - SNR
// - modulation type : ASK / BPSK / M-PSK / FSK / ...
// - Frequency error ==> qu'on va supposer nulle (utilisation de la ped au
// sein d'une boucle)
// - Amplitude of fixed phase error ==> qu'on va supposer faible (même raison) 

// Squaring loop + atan(...)
// Squaring loop + Im(...) / RSSI


function zb = make_signal(n,sigma,M,phiv)



phase_noise = exp(%i*phiv);
s = grand(n,1,"uin",0,peds(1).M - 1);
fs = 100e3;     // Sampling frequency: 1 MHz
fi = 0;   // Intermediate frequency: 200 KHz
fsymb = 10e3; // 10Ksymbols/second

// Simulate a BPSK signal
wf = wf_init('psk', M);
wf = wf_set_filter(wf, 'rc', 15, 0.1);
//wf = wf_set_filter(wf, 'nrz');
mod = mod_init(wf,fs,fi,fsymb);
b = prbs(10 + n / mod.ovs);
[mod,z] = mod_process(mod,b);
zb = z(1:n);
zb = zb .* phase_noise;
zb = awgn(zb,sigma);
endfunction


function test_peds(peds,cols,sigma)

// Test signal : varying phase error from -%pi to +%pi



n = 3000;
PHI_MAX = (2 * %pi / peds(1).M) / 8;
phiv = 2*PHI_MAX*(rand(n,1,'u')-0.5);
zb = make_signal(n,sigma,peds(1).M,phiv);

//zb = z .* exp(2*%pi*%i*s/peds(1).M);
//zb = awgn(z, sigma, 'c');

npeds = length(peds);
phi = zeros(n,npeds);

for i = 1:npeds
    printf("Test ped [%s]...\n", peds(i).id);
    [peds(i),phi(:,i)] = peds(i).process(peds(i), zb);
end

scf(2); clf();
plot_const(zb);
scf(3); clf();
plot(real(zb),'b-o');

legs = [];
// Notice phase ambiguity due to the squaring
scf(0); clf();

for i = 1:npeds
  plot(phiv*180/%pi, phi(:,i)*180/%pi, cols(i));
  legs = [legs ; peds(i).id];
end;
plot(phiv*180/%pi,phiv*180/%pi,'k-');
//plot(phi*180/%pi, ped_atan*180/%pi, 'c+');
//plot(phi*180/%pi, ped1*180/%pi, 'm.');
legend([legs;'True phase']);
xtitle("Phase detection", "True phase (degrees)", "Detected phase");

scf(4); clf();
for i = 1:npeds
subplot(npeds,1,i);
plot_const(phiv*180/%pi, phi(:,i)*180/%pi);
a = gca();
a.data_bounds = [-PHI_MAX*180/%pi,PHI_MAX*180/%pi,-PHI_MAX*180/%pi,PHI_MAX*180/%pi];
xtitle("Scatter plot (" + peds(i).id + ")");
end

scf(1); clf();
for i = 1:npeds
  plot(phiv*180/%pi, (phi(:,i)-phiv)*180/%pi, cols(i));
  legs = [legs ; peds(i).id];
end;
legend(legs);
xtitle("Phase error")

//scf(2); clf();
//plot(ped.rssi);
for i = 1:npeds
rms = mean((phi(:,i)-phiv) .^ 2);
printf("RMS %s: %f.\n", peds(i).id, rms);
end;


endfunction








function test_peds_vs_snr(peds, cols)


N = 1000;
phi = (%pi/16)*ones(N,1);    


//z = exp(%i*phi);
n = 51;
SNR = (linspace(-5,20,n))';
npeds = length(peds);


rms = zeros(n,npeds);
s = zeros(n,1);

for i = 1:n
    sigma = 10^(-SNR(i)/20);
    z = make_signal(N,sigma,peds(1).M,phi);
    
    s(i) = sigma;
    zb = awgn(z, sigma, 'c');
    for j = 1:npeds
      [peds(j),phic] = peds(j).process(peds(j), zb);
      rms(i,j) = mean((phic-phi) .^ 2) / mean(phi .^ 2);
    end;
end

scf(3); clf();
legs = [];
for j = 1:npeds
  plot(SNR, 10*log10(rms(:,j)), cols(j));
  legs = [legs ; peds(j).id];
end
xtitle("Phase estimation error vs SNR", "SNR (dB)", "Phase error (dB)");
legend(legs);
endfunction



//xdel(winsid()); // Ferme tout
peds = list();
M = 2; tc = 1e9;

//peds(2) = ped_init('psk-map', M, tc);
peds(1) = ped_init('psk-atan', M, tc);
peds(2) = ped_init('costa', M, tc);
peds(3) = ped_init('psk', M, tc);

sigma = 0.1e-8;
cols = ['bo','mo','g+'];
//test_peds(peds,cols,sigma);

cols = ['b-','m-o','g-'];
test_peds_vs_snr(peds,cols);







