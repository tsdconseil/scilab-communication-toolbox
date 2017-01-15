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

function [dn,y] = downconvert_process(dn,x)
// Down-conversion to baseband.
// 
// Calling Sequence
// [dn,y] = downconvert_process(dn,x)
//
// Parameters
// x: input signal (real or complex)
// dn: downconversion object (created with <link linkend="downconvert_init">downconvert_init</link>)
// y: output baseband signal (complex)
// 
// Description
// If the input signal is complex, no image filtering is down.
// If the input signal is real, image is removed with a low-pass filter
// with cut-off frequency set to <latex>$\nu$</latex> if <latex>$\nu < \frac{1}{4}$</latex>, and <latex>$\frac{1}{2}-\nu$</latex>  otherwise,
// where <latex>$\nu$</latex> is the normalized intermediate frequency
// (in either case, half-way between baseband signal and image signal).
// 
// <refsection><title>Example 1: downconversion of a BPSK complex signal (without image filtering)</title></refsection>
// <programlisting>
// // Load RF test signal (BPSK, I/Q)
// [x,fs,fi,fsymb] = sct_test_signal('c');
// ;
// // Down-conversion to baseband
// dn = downconvert_init(fi/fs,'c');
// [dn,y] = downconvert_process(dn,x);
// </programlisting>
// Scatter plot view:
// <imageobject><imagedata fileref="ex_downconvert1_const.png" format="PNG"/></imageobject>
// Frequency view:
// <imageobject><imagedata fileref="ex_downconvert1_psd.png" format="PNG"/></imageobject>
// 
// <refsection><title>Example 2: downconversion of a BPSK real signal (with image filtering)</title></refsection>
// <programlisting>
// // Load RF test signal (BPSK, I/Q)
// [x,fs,fi,fsymb] = sct_test_signal();
// ;
// // Down-conversion to baseband
// dn = downconvert_init(fi/fs,'r');
// [dn,y] = downconvert_process(dn,x);
// </programlisting>
// Scatter plot view:
// <imageobject><imagedata fileref="ex_downconvert2_const.png" format="PNG"/></imageobject>
// Frequency view:
// <imageobject><imagedata fileref="ex_downconvert2_psd.png" format="PNG"/></imageobject>
//
// See also
//  downconvert_init
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

x = x(:);
n = length(x);
y = x .* exp(-2*%pi*%i*dn.nu*(0:n-1)');

if(dn.opt == 'r')
  [y,e2] = convol(dn.h,y',dn.e);
  dn.e = e2;
  y = y';
end;

endfunction
