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

function plot_scurve(ted,varargin)
// Plot the S-curve of a timing error detector (TED)
//
// Calling Sequence
//  plot_scurve(ted)
//  plot_scurve(ted,opt)
// 
// Parameters
// ted: Timing error detector object (as returned by the <link linkend="ted_init">ted_init</link> function)
// opt: Optional plotting string option (see <varname>plot()</varname> documentation)
// 
// Description
//  Plot the curve of the result of the TED versus real timing error.
// <refsection><title>Example</title></refsection>
// <programlisting>
//  clf();
//  plot_scurve(ted_gardner());
// </programlisting>
// <imageobject><imagedata fileref="ex_plot_scurve.png" format="PNG"/></imageobject>
//
// See also
//  scurve
//  ted_init
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>    
    
    rhs = argn(2);
    [tau,s] = scurve(ted);
    if(rhs == 1)
        plot(tau,s);
    else
        plot(tau,s,varargin(1));
    end;
    plot(tau/2,tau/2,'g-');
    xtitle("S-curve", "Real timing error (in samples)", "Output of timing error detector");
    legend([ted.name 'Ideal'])
endfunction


