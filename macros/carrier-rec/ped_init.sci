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

function ped = ped_init(tp,M,varargin)
// Phase error detector for BPSK / M-ASK (squaring loop) and M-PSK (<latex>$z^M$</latex> loop)
// 
// Calling Sequence
// ped = ped_init(tp,M[,tc])
// 
// Parameters
// tp: Type of phase detector (can be 'psk', 'costa', 'psk-atan', 'psk-map', or 'ask')
// M: Number of possible symbols (<latex>$M=2^k$</latex> with <latex>$k$</latex> being the number of bits per symbol)
// tc: Time constant for coarse RSSI estimation (expressed in number of samples)
// ped: Phase error detector object. Fields are: <varname>ped.process</varname>: processing function of form <varname>[ped,dphi] = process(ped,z)</varname>, with <varname>dphi</varname>: phase error, and <varname>z</varname>: input sample, other fields are private.
// 
// Description
// This is a basic phase error detector for M-PSK (or M-ASK). 
// Different type of detectors are supported:
// <itemizedlist>
//   <listitem><para><emphasis role="bold">tp = 'psk'</emphasis> The signal is exponentiated by M so as to remove the modulation, the RSSI is coarsly estimated (first order IIR filter), and then the phase error is estimated as: 
// <latex>$$d\phi = \frac{\mathbf{Im}\left(z^M\right)}{M \cdot \textrm{RSSI}^M}$$</latex>.
// This detector is less sensible to noise as the naive atan detector.</para></listitem>
//   <listitem><para><emphasis role="bold">tp = 'psk-atan'</emphasis>  Arc-tangent phase detector for PSK modulation (also called 'tan-loop'), computed as: 
// <latex>$$d\phi = \tan^{-1}(z^M)/M$$</latex>.
// Be carefull, this detector can be very unreliable at low SNR or when clock recovery is not yet done (very high artificial phase error when the signal magnitude is near 0).</para></listitem>
//   <listitem><para><emphasis role="bold">tp = 'psk-costa'</emphasis> Use a costa loop (works only with BPSK or QPSK).</para></listitem> 
//   <listitem><para><emphasis role="bold">tp = 'ask'</emphasis> If M=2, then use a squaring loop (as for BPSK), otherwise, use a tan-loop.</para></listitem>   
// </itemizedlist>
//
// <refsection><title>Example</title></refsection>
// <programlisting>
//  // Default PED for BPSK (squaring loop)
//  ped = ped_init('psk',2); 
//  n = 100;
//  // Test signal : varying phase error from -%pi to +%pi
//  phase = linspace(-%pi,%pi,n)';
//  z = exp(%i*phase);
//  // Use the PED on the signal "z"
//  detected_phase = ped.process(ped, z);
//  // Notice phase ambiguity due to the squaring
//  clf(); plot(phase,detected_phase);
// </programlisting>
// <mediaobject><imageobject><imagedata fileref="ex_ped_psk.png" format="PNG"/></imageobject><caption><para>Example of phase error detection (here squaring loop, e.g. M=2). Note the phase ambiguity of <latex>$\pi$</latex>.</para></caption></mediaobject>
// See also
//  carrier_rec_init
//  carrier_rec_process
//  
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>    


function dphi = psk_costa_process(ped,z)
  // QPSK : m^4 = 1
  if(ped.M == 2)
    // BPSK : m² = 1
    // sin(phi) * cos(phi) = 0.5 sin(2phi) ~ phi
    // Note: c'est la même chose qu'une squaring loop
    // en prenant slmt la partie imaginaire.
    dphi = real(z) .* imag(z);
  elseif(ped.M == 4)
    // QPSK costa loop locks to square constellation
    // And we expect a "losange" constellation. 
    z = z * exp(%i*%pi/4);
    dphi = imag(z) .* sign(real(z)) - real(z) .* sign(imag(z));
  else
      error("psk_costa: expect BPSK or QPSK.");
  end;
endfunction;

// Squaring loop
function dphi = psk_sqloop_process(ped,z)
   dphi = imag(z .^ ped.M) ./ ped.M;
endfunction

// MAP (equivalent to squaring loop)
function dphi = psk_map_process(ped,z)
  angle = modulo(atan(imag(z),real(z)) + 8 * %pi, 2 * %pi);
  angle_2 = (2 * %pi / ped.M) .* round((angle .* ped.M) / (2 * %pi));
  dphi = angle - angle_2;
endfunction

// Tan-loop
function dphi = psk_atan_process(ped,z)
   dphi = atan(imag(z .^ ped.M),real(z .^ ped.M)) / ped.M;
endfunction




ped.M       = M;
ped.tc      = 5;
if(argn(2) > 2)
    ped.tc = varargin(1);
end
ped.require_clk_rec = %f;
ped.require_agc     = %f;

select tp
case 'psk'
    ped = ped_init('psk-rssi', M, ped.tc);
case 'psk-atan'
    ped.id      = "Squaring loop / atan"
    ped.process = psk_atan_process;
    ped.require_clk_rec = %t;
case 'psk-map' then
    ped.id = 'M-PSK map';
    ped.process = psk_map_process;
case 'psk-rssi' then
    ped.id      = "Squaring loop / Imag";
    ped.process = psk_sqloop_process;
    ped.require_agc = %t;
case 'costa' then
    ped.id      = "Costa loop";
    ped.process = psk_costa_process;
    ped.require_clk_rec = %f;
    ped.require_agc = %t;
case 'ask' then
    if(M == 2)
      ped = ped_init('psk-rssi', 2, ped.tc);
    else
      ped = ped_init('psk-atan', 2, ped.tc);
    end;
else
    error(sprintf('ped_init: unknown type ''%s''.', tp));
end

//if(ped.require_agc & (argn(2) < 3))
//    error("ped_init(): this detector requires a coarse RSSI estimation.\n Please provide a time constant (third argument of ped_init()) for the RSSI filtering.");
//end;

    
endfunction

