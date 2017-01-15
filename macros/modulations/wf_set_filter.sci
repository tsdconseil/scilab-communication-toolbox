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

function wf = wf_set_filter(wf, ftype, varargin)
// Specification of the pulse shaping filter for a waveform
//
// Calling Sequence
// wf = wf_set_filter(wf, 'none');
// wf = wf_set_filter(wf, 'nrz');
// wf = wf_set_filter(wf, 'rc', ntaps, roll_off);
// wf = wf_set_filter(wf, 'srrc', ntaps, roll_off);
// wf = wf_set_filter(wf, 'gaussian', ntaps, BT);
//
// Parameters
//  roll_off: Roll-off factor (for RC / SRRC filters)
//  BT: Bandwidth-time product (for gaussian filter)
//  ntaps: Number of taps of the FIR filter (for implementation of RC, SRRC or Gaussian filters)
//
// Description
//  Note that if a gaussian filter is specified, actually what is implemented
//  is the convolution of a gaussian filter with a moving average filter (of length given
//  by the symbol period), or, saying it another way, the gaussian filter is applied
//  to a signal preformated using NRZ.
// 
// <refsection><title>Example</title></refsection>
// <programlisting>
//  wf = wf_init('bpsk'); // Default pulse shaping is NRZ
//  // Change it to SRRC (with a roll-off of 0.2)
//  wf = wf_set_filter(wf, 'srrc', 0.2)
// </programlisting>
// 
// See also
//  wf_init
//  ps_filter_init
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

    // The pulse shaping filter is really initialized afterwards inside
    // a modulation object (because for now we don't know yet the output
    // sampling frequency, and thus the oversampling ratio).
    
    wf.ftype  = ftype;
    wf.fparam = varargin;
endfunction


