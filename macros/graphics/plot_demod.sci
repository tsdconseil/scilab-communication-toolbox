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

function plot_demod(dmd)
// Plot the demodulation intermediate results
//
// Calling Sequence
// plot_demod(dbg)
//
// Parameters
//  dbg: Debug structure as returned by <link linkend="demod_process">demod_process</link>
// 
// Description
// This function plots the following figures:
// <itemizedlist>
//   <listitem>PSD before and after down-conversion</listitem>
//   <listitem>Demodulation steps (downconversion, carrier recovery, matched filtering, clock recovery) in time and constellation view.</listitem>
//   <listitem>Clock recovery convergence</listitem>
// </itemizedlist>
// 
// See also
//  demod_process
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

f = scf(1); clf();
f.figure_name = "Down-conversion";
subplot(211);
plot_psd(dmd.x);
xtitle("Input signal");
subplot(212);
plot_psd(dmd.xdn);
xtitle("After downconversion");


f = scf(2); clf(); 
f.figure_name = "Clock recovery";
subplot(311);
plot(dmd.cr.e);
xtitle("Timing error detector", "Time (in symbols)", "Error (in multiple of symbol period)");
a = gca();
a.title.font_size = 3;
subplot(312);
plot(dmd.cr.dec  / dmd.demod.osf);
xtitle("Phase corrections", "Time (in symbols)", "Phase correction (in multiple of symbol period)");
a = gca();
a.title.font_size = 3;
subplot(313);
plot(dmd.cr.mu / dmd.demod.osf);
//xtitle("Instantaneous phase", "Time (in symbols)", "Phase (in input sampling period)");
xtitle("Instantaneous phase", "Time (in symbols)", "Phase (in multiple of symbol period)");
a = gca();
a.title.font_size = 3;


f = scf(3); clf();
f.figure_name = "Demodulation steps (time view)";
subplot(611); plot([real(dmd.x) imag(dmd.x)]);
xtitle("Input signal");
subplot(612); plot([real(dmd.xdn) imag(dmd.xdn)]);
xtitle("After downconversion");
subplot(613); plot([real(dmd.xcr) imag(dmd.xcr)]);
xtitle("After carrier recovery");
subplot(614); plot([real(dmd.xmf) imag(dmd.xmf)]);
xtitle("After matched filter");
subplot(615); plot([real(dmd.xclkr) imag(dmd.xclkr)]);
xtitle("After clock rec");
subplot(616); plot([real(dmd.xagc) imag(dmd.xagc)]);
xtitle("After AGC");

f = scf(4); clf();
f.figure_name = "Demodulation steps (scatterplot view)";
subplot(321); plot_const(dmd.x);
xtitle("Input signal");
subplot(322); plot_const(dmd.xdn);
xtitle("After downconversion");
subplot(323); plot_const(dmd.xcr);
xtitle("After carrier recovery");
subplot(324); plot_const(dmd.xmf);
xtitle("After matched filter");
subplot(325); plot_const(dmd.xclkr);
xtitle("After clock rec");

if(isfield(dmd, 'crrdbg'))
f = scf(5); clf();
f.figure_name = "Carrier recovery";
subplot(421); plot(dmd.crrdbg.pe * 180 / %pi);
xtitle('Phase error (degree)');
subplot(422); plot(dmd.crrdbg.mu);
xtitle('Frequency of local oscillator');
subplot(423); plot(dmd.crrdbg.theta * 180 / %pi);
xtitle('Phase of local oscillator (degree)');
subplot(424); plot(dmd.crrdbg.crssi);
xtitle('Coarse RSSI estimation');
subplot(425); plot(dmd.crrdbg.rphi * 180 / %pi);
xtitle('Real phi of incoming signal (degree)');
subplot(426); plot(dmd.crrdbg.rdphi * 180 / %pi);
xtitle('Real dphi of incoming signal VS LO (degree)');
subplot(427); plot(dmd.crrdbg.vabs);
xtitle('Input amplitude');
subplot(428); plot(dmd.crrdbg.imag);
xtitle('Imaginary part');
end;

f = scf(6); clf();
f.figure_name = "Coarse RSSI estimation";
subplot(211);
plot(dmd.ax);
xtitle("Instantaneous signal amplitude");
subplot(212);
plot(dmd.coarse_rssi);
xtitle("Coarse RSSI");
endfunction

