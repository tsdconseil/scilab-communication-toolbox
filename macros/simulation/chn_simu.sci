
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

function y = chn_simu(x,prm)
// Radio channel simulation (noise, phase error, frequency error, ...)
// Calling Sequence
// y = chn_simu(x,prm);
// Parameters
// x:   input RF signal
// prm: structure defining the channel parameters (can be initialized with <link linkend="chn_simu_prm">chn_simu_prm</link>)
// y:   output, distorted, RF signal
// Description
//  This function simulates various distortions than can arise through a radio
//  propagation channels. The parameter structure enables to specify the different
//  possible distortions is documented <link linkend="chn_simu_prm">here</link>.
//
// <refsection><title>Example</title></refsection>
// <programlisting>
//prm = chn_simu_prm();
//// Add white noise
//prm.sigma_wn = .1;
//mod = mod_init('qpsk',fs=1e6,fi=100e3,fsymb=10e3,'c');
//[mod,x] = mod_process(mod,prbs(nsymb=100));
//scf(0); clf(); plot_const(x); xtitle("Before channel");
//x = chn_simu(x,prm);
//scf(1); clf(); plot_const(x); xtitle("After channel");
// </programlisting>
// <mediaobject><imageobject><imagedata fileref="ex-chn-simu2.png" format="PNG"/></imageobject><caption><para>Before and after channel simulation</para></caption></mediaobject> 
// Examples
// 
//
// See also
//  chn_simu_prm
//  awgn
//
// Authors
//  J.A., full documentation available at http://www.tsdconseil.fr/log/sct

    
x = awgn(x, prm.sigma_wn);
// Délais sur la porteuse
// <=> Erreur de phase sur la porteuse
// + erreur de timing sur le signal
x = frac_delay(x, prm.delta_t); // Pb frac_delay : génére des artefacts
//x = x(1+prm.delta_t:$);

// Ecart de phase sur la porteuse
x = x .* exp(2*%i*prm.phase_offset);//%pi/4);

t = linspace(0,(length(x)-1)/fs,length(x))';
fres = 11;
x = x .* exp(%i*2*%pi .* t .* prm.freq_offset);

y = x;
endfunction




