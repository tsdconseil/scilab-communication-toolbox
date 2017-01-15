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

function p = chn_simu_prm(varargin)
// Radio channel simulation (noise, phase error, frequency error, ...)
//
// Calling Sequence
// prm = chn_simu_prm();
//
// Parameters
// prm: Resulting structure defining the channel parameters.
// 
// Description
//  This function enables to initialize the field of a structure defining which distortions 
// to use when simulating a radio
//  propagation channel with the <link linkend="chn_simu">chn_simu</link> function.
//  By default, all channel distortions are disabled. One can activate them selectivly by 
//  modifying the following fields:
// <itemizedlist>
//   <listitem><emphasis role="bold">White noise:</emphasis> <varname>prm.sigma_wn</varname> = standard deviation of the white noise.</listitem>
//   <listitem><emphasis role="bold">Time shift:</emphasis> <varname>prm.delta_t</varname> = timing offset between receiver and transmitter clock (in samples).</listitem>
//   <listitem><emphasis role="bold">Frequency offset:</emphasis> <varname>prm.freq_offset</varname> = frequency offset (compared to expected carrier frequency).</listitem>
//   <listitem><emphasis role="bold">Phase offset:</emphasis> <varname>prm.phase_offset</varname> = carrier phase offset (in radians).</listitem>
// </itemizedlist>
// Note: TODO : complete with other possible source of distortions (selective channel, I/Q imbalance, clock offset, ...)
// 
// Examples
// // Default channel configuration
// prm = chn_simu_prm();
// // Add white noise (sigma = 0.1)
// prm.sigma_wn = 0.1;
// 
// See also
//  chn_simu
//
// Authors
//  J.A., full documentation available at http://www.tsdconseil.fr/log/sct


    p.sigma_wn      = 0;
    p.delta_t       = 0;
    p.freq_offset   = 0;
    p.phase_offset  = 0;

endfunction;



