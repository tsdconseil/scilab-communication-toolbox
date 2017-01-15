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

function [g,varargout] = iir1_design(tp, val)
// Design of a single pole lowpass IIR filter.
// 
// Calling Sequence
//  g = iir1_design('fc', fc);
//  g = iir1_design('tc', tc);
//  [g,h] = iir1_design(...);
//
// Parameters
// tp: type of design parameter ('fc' for cutoff frequency or 'tc' for time constant)
// fc: Normalized cut-off frequency (between 0 and 0.5)
// tc: Time constant, in samples
// g: Forget factor
// h: Filter transfert function (z transform, rationnal function)
//
// Description
// Compute the forget factor of a first order lowpass IIR filter (and optionnaly the whole transfert function), of equation:
//
// <latex>$$y_{n+1} = y_n + g\cdot(u_n-y_n) = (1-g)\cdot y_n + g\cdot x_n$$</latex>
// <refsection><title>Example</title></refsection>
// <programlisting>
// // Set Fcut-off = 0.1 * sample rate
// [g,h] = iir1_design('fc', 0.1);
// [xm,fr] = frmag(h,512);
// clf(); plot(fr,xm);
// </programlisting>
// <mediaobject><imageobject><imagedata fileref="ex_iir1_design.png" format="PNG"/></imageobject><caption><para>Magnitude response of a IIR1 lowpass filter designed with iir1_design</para></caption></mediaobject>
// 
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>    

    if(tp == 'tc')
        if(val > 0)
          fc = 1 / (2 * %pi * val);
        else
          g = 1.0;
        end;
    elseif(tp == 'fc')
        fc = val;
    else
        error("iir1_design: invalid parameter.");
    end;
    if((tp ~= 'tc') | (val > 0))
      g = 1.0 - exp(-2*%pi*fc);
    end;
    if(argn(1) > 1)
        h = g / (%z - 1 + g);
        varargout = list(h);
    end;
endfunction

