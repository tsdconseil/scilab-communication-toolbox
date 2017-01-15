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


fs = 8*20e3;
fi = 0;
fsymb = 20e3;
osf = fs / fsymb;
modt = 'qpsk';
nsymb = 1000;

prm = chn_simu_prm();

prm.sigma_wn = 0.04;
prm.delta_t  = osf/2;
prm.fres = 11;

grand('setsd', 4648721);

wf = wf_init(modt);
//wf = wf_set_filter(wf, 'g', 3*osf, 0.5);
wf = wf_set_filter(wf, 'nrz');

// QPSK demodulator (NRZ matched filter),
// sampling frequency = 1 MHz, IF = 200 KHz, FSYMB = 20 KHz
demod = demod_init(wf, fs, fi, fsymb);
  
// Create a modulator to simulate RF signal
mod = mod_init(wf, fs, fi, fsymb);
b1 = prbs(nsymb);
[mod,x] = mod_process(mod,b1);

x = chn_simu(x,prm);

// Proceed to demodulation
[demod,b2,y,dbg] = demod_process(demod, x);
//plot_demod(dbg);

scf(0); clf();
//subplot(321); plot_const(dmd.x);
//xtitle("Input signal");
subplot(221); plot_const(dbg.xdn);
xtitle("Signal bande de base");
a = gca(); a.title.font_size = 4;
subplot(222); plot_const(dbg.xcr);
xtitle("Après recouvrement de porteuse");
a = gca(); a.title.font_size = 4;
subplot(223); plot_const(dbg.xmf);
xtitle("Après filtrage adapté");
a = gca(); a.title.font_size = 4;
subplot(224); plot_const(dbg.xclkr);
xtitle("Après recouvrement d''horloge");
a = gca(); a.title.font_size = 4;

xs2png(gcf(),'c:/dev/formations/sdr/presentation/mods/qpsk-ex-coh-demod.png');



