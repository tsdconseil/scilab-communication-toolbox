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

function test(Omega_c, phi_c, cr)

n = 200;
phi = linspace(-%pi,%pi,n)';
z1 = 2*ts01(n)-1;
z1 = awgn(z1, 0.05, 'c');

n = length(z1);
phase_ref = ((0:n-1)'.*Omega_c+phi_c);

z1 = z1 .* exp(%i*phase_ref);

z2 = zeros(n,1);


[cr,z2,dbg] = carrier_rec_process(cr,z1);

cdir = get_absolute_file_path("ex_carrier_rec_process.sce");

scf(0); clf();
subplot(211);
plot_const(z1);
xtitle("Input of carrier recovery");
a = gca(); a.title.font_size = 4;
subplot(212);
plot_const(z2);
a = gca(); a.title.font_size = 4;
xtitle("Output of carrier recovery");



scf(1); clf();
subplot(211);
plot(dbg.pe);
xtitle("Phase error");
a = gca(); a.title.font_size = 4;
subplot(212);
plot(modulo(dbg.theta,2*%pi));
plot(modulo(phase_ref,2*%pi),'g-');
xtitle("Local oscillator phase");
legend(['Phase détectée';'Phase vraie']);
a = gca(); a.title.font_size = 4;

endfunction


/// (1) Test First Order PLL, sans offset de fréquence
Omega_c = 0;
phi_c   = 0.7*%pi/2;
cr = carrier_rec_init(ped_init('psk',2,5), lf_init(1, 5));
test(Omega_c, phi_c, cr);
xs2png(0, 'c:/dev/formations/sdr/presentation/carrier-rec/ex-fo-phase-1.png');
xs2pdf(1, 'c:/dev/formations/sdr/presentation/carrier-rec/ex-fo-phase-2.pdf');

/// (2) Test First Order PLL, avec offset de fréquence
Omega_c = 2*%pi / 100;
phi_c   = 0.7*%pi/2;
cr = carrier_rec_init(ped_init('psk',2,5), lf_init(1, 5));
test(Omega_c, phi_c, cr);
xs2png(0, 'c:/dev/formations/sdr/presentation/carrier-rec/ex-fo-1.png');
xs2pdf(1, 'c:/dev/formations/sdr/presentation/carrier-rec/ex-fo-2.pdf');

/// (3) Test Second Order PLL, avec offset de fréquence
Omega_c = 2*%pi / 100;
phi_c   = 0.7*%pi/2;
cr = carrier_rec_init(ped_init('psk',2,5), lf_init(2, 0.1,1));
test(Omega_c, phi_c, cr);
xs2png(0, 'c:/dev/formations/sdr/presentation/carrier-rec/ex-so-1.png');
xs2pdf(1, 'c:/dev/formations/sdr/presentation/carrier-rec/ex-so-2.pdf');









//xs2png(0, cdir + '../../help/en_US/carrier-rec/ex_carrier_rec_process1.png');
//xs2png(1, cdir + '../../help/en_US/carrier-rec/ex_carrier_rec_process2.png');
