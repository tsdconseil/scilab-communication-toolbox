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



function [cr,z2,varargout] = carrier_rec_process(cr,z1)
// Main process for the carrier recovery
//
// Calling Sequence
// [cr,z2] = carrier_rec_process(cr,z1)
// [cr,z2,dbg] = carrier_rec_process(cr,z1);
//
// Parameters
// cr: Carrier recovery object
// z1: Input I/Q sample
// z2: Output I/Q sample, frequency and phase corrected
// dbg: Optional debug information (recovered carrier)
//
// Description
//   Run a local oscillator tuned to the input signal through a phase error detector and a loop filter. The local oscillator is used to correct the phase and frequency of the input signal:
//   <latex>$z_2 = z_1 e^{-2\pi \mathbf{i} \theta}$</latex>, with <latex>$\theta=$</latex> current phase of the local oscillator.
//
// <refsection><title>Example</title></refsection>
// <programlisting>
//// Build a BPSK signal
//mod = mod_init('bpsk',fs=1,fi=0,fsymb=1);
//[mod,z1] = mod_process(mod,prbs(100));
//// With some noise and phase offset
//z1 = awgn(z1, 0.05, 'c') .* exp(%i*0.7*%pi/2);
////
//// Build a carrier recovery object
//ped = ped_init('psk', 2, tc = 10); // Default PED for BPSK
//lf = lf_init(1, tc = 10); // First order loop filter
//cr = carrier_rec_init(ped, lf);
////
//// Proceed to carrier recovery
//[cr,z2] = carrier_rec_process(cr,z1);
////
//scf(0); clf();
//subplot(211);
//plot_const(z1);
//xtitle("Input of carrier recovery");
//subplot(212);
//plot_const(z2);
//xtitle("Output of carrier recovery");
// </programlisting>
// <mediaobject><imageobject><imagedata fileref="ex_carrier_rec_process1.png" format="PNG"/></imageobject><caption><para>Example: BPSK signal with phase offset before and after carrier recovery.</para></caption></mediaobject>
//
// See also
//  carrier_rec_init
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>    
    
    n = length(z1);
    z2 = zeros(n,1);
    dbg.pe    = zeros(n,1);
    dbg.theta = zeros(n,1);
    dbg.mu    = zeros(n,1);
    dbg.crssi = zeros(n,1);
    dbg.rphi  = zeros(n,1);
    dbg.vabs  = zeros(n,1);
    dbg.imag  = zeros(n,1);
    for  i = 1:n
      
      z2(i) = z1(i) * exp(-%i*cr.theta);
      zagc = z2(i);
      if(cr.ped.require_agc)
          cr.rssi = (1-cr.g) * cr.rssi + cr.g * abs(zagc);
          dbg.crssi(i) = cr.rssi;
          zagc = zagc / cr.rssi;
      end;
      dphi = cr.ped.process(cr.ped, zagc);
      [cr.lf,theta] = cr.lf.process(cr.lf, dphi);
      cr.theta = theta;
      dbg.pe(i) = dphi;
      dbg.theta(i) = theta;
      if(isfield(cr.lf, 'mu'))
        dbg.mu(i) = cr.lf.mu;
      end;
      dbg.rphi(i) = atan(imag(z1(i)),real(z1(i)));
      dbg.rdphi(i) = atan(imag(z2(i)),real(z2(i)));
      dbg.vabs(i) = abs(z1(i));
      dbg.imag(i) = imag(z2(i));
    end
    
    
    
    if(argn(1) > 2)
        varargout = list(dbg);
    end;
    //[cr.ped,dphi] = cr.ped.process(cr.ped, z1);
    //[cr.so,theta] = cr.so.process(cr.so, dphi);
    //z2 = z1 * exp(-2*%pi*%i*theta);
endfunction


