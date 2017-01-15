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

function plot_rimp(varargin)
// Plotting of impulsionnal response of a FIR filter
// 
// Calling Sequence
//  plot_rimp(h);
//  plot_rimp(t,h,opt);
//
// Parameters
// h: filter impulse vector (1d vector)
// t: optionnal abcisse vector
// opt: Optionnal parameters for the plot function (color / marker selections)
//
// Description
// This function is just a wrapper around native <varname>plot2d3</varname> function, specialized for FIR coefficients display.
// <refsection><title>Example</title></refsection>
// <programlisting>
// h = hilb(33); // Get Hilbert FIR filter approximation (33 coefs.)
// clf(); plot_rimp(h);
// </programlisting>
// <imageobject><imagedata fileref="ex_plot_rimp.png" format="PNG"/></imageobject>
//
// See also
//  plot_psd
//  plot_const
//  plot_eye
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

    rhs = argn(2);
    col = 'blue';
    
    
    if(rhs == 1) then
        y = varargin(1);
        n = length(y);
        x = 0:n-1;
    elseif(rhs >= 2) then
        x = varargin(1);
        y = varargin(2);
        n = length(y);
        if(rhs == 3)
            col = varargin(3);
        end;
    else
        error("plot_rimp: Invalid arg count.");
    end;
    
    plot2d3(x,y,style=color(col));
    plot(x,y,'o' + part(col,1));
    //plot2d3(x,y,style=color("blue"));
    //plot(x,y,'ob');
endfunction
