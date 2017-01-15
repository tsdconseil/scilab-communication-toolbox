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


function plot_binary(b)
// Plot a binary stream
//
// Calling Sequence
// plot_binary(b)
//
// Parameters
// b: Binary vector (two values)
//
// Description
// This function just plots a binary sequence (1d vector), and ajusts the viewing area so 
// as to avoid to cut the min and max value.
// 
// <refsection><title>Example</title></refsection>
// <programlisting>
// x = prbs(50); // Sequence of 50 random bits
// scf(0); clf();
// plot_binary(x);
// </programlisting>
// <mediaobject><imageobject><imagedata fileref="ex_plot_binary.png" format="PNG"/></imageobject><caption><para>Random binary sequence</para></caption></mediaobject> 
// 
// See also
//  plot_psd
//  plot_rimp
//  plot_eyed
//  wf_init
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>
    
    b = clean(b(:));
    n = length(b);
    t = (0:n-1)';
    plot(t,b,'o-');
    a = gca();
    
    ymax = max(1.1, max(b)+0.1);
    ymin = min(-0.1, min(b)-0.1);
    a.data_bounds = [0 ymin ; n-1 ymax];
    
    
endfunction
