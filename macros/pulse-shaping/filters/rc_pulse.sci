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

function y = rc_pulse(t,r)
// Raised cosine pulse
//
// Calling Sequence
//   y = rc_pulse(t,roll_off)
//
// Parameters
// t: time, in multiple of symbol period (1 = 1 symbol period)
// r: roll-off factor
//
// Description
// Compute 
// <latex>$$y(t)=\sinc(\pi t) \frac{\cos(\pi rt)}{1-4r^2t^2}$$</latex>
//
// Examples
// t = linspace(-10,10,1000);
// y = rc_pulse(t,0.5);
// clf(); plot(t,y);
//
// See also
//  rc_fir
//  srrc_pulse
//  srrc_fir
//
// Authors
//  J.A., full documentation available on www.tsdconseil.fr/log
// Bibliography
//  Multirate signal processing for communication systems, F.J. Harris, page 89.

    n = length(t);
    m = length(r);
    y = zeros(m,n);
    
    for i = 1:n
        for j = 1:m 
      if (r(j) > 0) & (abs(t(i)) == 1 / (2*r(j))) then
        y(j,i) = sinc(%pi*t(i)) * %pi / 4;//-sinc(%pi*t(i)) * %pi * %pi / 8;
      else
        y(j,i) = sinc(%pi*t(i)) * cos(%pi*r(j)*t(i)) / (1 - 4 * r(j) * r(j) * t(i) * t(i));
      end;
      end;
    end;
endfunction
    
