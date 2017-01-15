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


function [demod,b,varargout] = demod_process(demod,x)
// Complete demodulation chain implementation (from a RF or IF signal to a binary sequence).
// 
// Calling Sequence
//  [demod,b] = demod_process(demod,x);
//  [demod,b,y] = demod_process(demod,x);
//  [demod,b,y,dbg] = demod_process(demod,x);
//
// Parameters
//  demod: Demodulation object (can be created with the function <link linkend="demod_init">demod_init</link>)
//  x: Input RF or IF signal
//  b: Decoded binary sequence (hard-decoding)
//  y: Decoded symbols, which can be used for soft-decoding (optionnal output parameter)
//  dbg: Debug structure, containing the intermediate results of the demodulation process  (optionnal output parameter)
// 
// Description
// Proceed to demodulation of the input signal.
// The demodulation consists in the following steps:
// <orderedlist>
//   <listitem><para><emphasis role="bold">Downconversion to baseband</emphasis> (if the configured intermediate frequency is not null), including image frequency filtering.</para></listitem>
//   <listitem><para><emphasis role="bold">Carrier recovery:</emphasis> detection and removing of carrier offset and residual frequency shift (with phase detector automatically choosen according to the currently used modulation scheme, and a second order loop)</para></listitem>
//   <listitem><para><emphasis role="bold">Matched filtering:</emphasis> filter matched to the pulse shaping filter (e.g. moving average for NRZ, or RC/SRRC filter for RC/SRRC pulses, etc.)</para></listitem>
//   <listitem><para><emphasis role="bold">Clock recovery:</emphasis> using an interpolator and a timing error detector automatically choosen according to  the modulation being used.</para></listitem>
//   <listitem><para><emphasis role="bold">Symbol demapping:</emphasis> conversion of the symbol sequence to a binary sequence using hard decoding (this step may not be used in the case of soft-decoding after the demodulation stage).</para></listitem>
// </orderedlist>
// 
// In case of frequency modulation (FSK, MSK, ...), 
// 
// <refsection><title>Example</title></refsection>
// <programlisting>
//  // QPSK demodulator (NRZ matched filter),
//  // sampling frequency = 1 MHz, IF = 200 KHz, FSYMB = 20 KHz
//  demod = demod_init('qpsk', 1e6, 200e3, 20e3);
//  //
//  // Create a modulator to simulate RF signal
//  mod = mod_init('qpsk', 1e6, 200e3, 20e3);
//  b1 = prbs(100); // Random bit vector
//  [mod,x] = mod_process(mod,b1);
//  //
//  // Proceed to demodulation
//  [demod,b2] = demod_process(demod, x);
//  //
//  // Alignment of the two bit vectors (and phase ambiguity resolution) 
//  [b1,b2,nerrs,ber] = cmp_bits(b1,b2,'p',demod.wf.k);
//  //
//  // Verification
//  if(nerrs ~= 0)
//    error("No noise case and error(s) are detected!");
//  end;
// </programlisting>
// 
// See also
//  demod_init
//  plot_demod
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>
    
    dbg.id = "Debug data for demod_process";
    
    dbg.demod = demod;
    dbg.x = x;
    
    // (1) Downconversion
    if(demod.fi ~= 0)
      [demod.dn,x] = downconvert_process(demod.dn, x);
    end;
    dbg.xdn = x;
    
    ////////////////////////////////
    // Channel filter ?
    // (no, hypothesis: white noise)
    ////////////////////////////////
    
    ///////////////////////////////////////////////
    /// FSK incoherent demodulation
    ///  --> No need for carrier recovery
    /// But, matched filter in the frequency domain ?
    ///////////////////////////////////////////////
    
    // (1') Coarse RSSI estimation
    coarse_rssi = abs(x);
    dbg.ax = coarse_rssi;
    [g,h] = iir1_design('tc', 10 * demod.osf); // 5 symbols
    coarse_rssi = flts(coarse_rssi',h,[1;1])';

    // (2) Carrier recovery
    if(~demod.wf.is_fsk)
      [demod.crr, x, dbg.crrdbg] = carrier_rec_process(demod.crr, x);
    end;
    
    //dbg.crrdbg = crrdbg;
    
    
    if(demod.wf.is_fsk)
        // Incoherent demodulation
        x = imag(x(2:$) .* conj(x(1:$-1))); 
    end;
    
    dbg.xcr = x;
    
    // (3) Matched filter
    [demod.psf,x] = psfilter_process(demod.psf,x);
    //x = x .* demod.osf; // Gain correction
    dbg.xmf = x;
    
    // PB ici: x n'a plus la même taille que coarse_rssi
    coarse_rssi = [coarse_rssi ; coarse_rssi($) * ones(length(x)-length(coarse_rssi),1)];
    
    
    dbg.coarse_rssi = coarse_rssi;
    
    // (3) Clock recovery
    [demod.cr,x,dbg.cr] = clock_rec_process(demod.cr, x, coarse_rssi);
    dbg.xclkr = x;
    
    // (4) Fine RSSI estimation
    ax = abs(x);
    // PB avec les modulations qui ne sont pas à amplitude constante !
    if(demod.wf.is_psk | demod.wf.is_fsk)
      [g,h] = iir1_design('tc', 3); // 3 symbol
      ax = flts(ax',h,[1;1])';
    else
       m = mean(ax);
       idx = find(ax > m / 2);
       ax = mean(ax(idx)) * ones(length(ax),1);
    end;

    dbg.rssi = ax;
    
    // (5) AGC
    x = x ./ ax;
    dbg.xagc = x;
    
    // (6) Demapping
    b = demod.wf.demodul(x);
    //b = real(0.5+sign(x2)/2); // bpsk trivial case
    dbg.b = b;
    
    if(argn(1) == 3)
        varargout = list(x);
    end;
    if(argn(1) == 4)
        varargout = list(x, dbg);
    end;
endfunction
