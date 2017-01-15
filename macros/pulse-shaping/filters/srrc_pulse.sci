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

function y = srrc_pulse(t,r)
// Square Root Raised Cosine pulse
// Calling Sequence
// y = srrc_pulse(t,r)
// Parameters
// t: time, in multiple of symbol period (1 = 1 symbol period)
// r: roll-off factor
//
// Bibliography
//  Multirate signal processing for communication systems, F.J. Harris, page 90.

    n = length(t);
    y = zeros(n,1);
    
    for i = 1:n

    
    if(t(i) == 0) then
        y(i) = (1-r) + 4*r/%pi;
    elseif (r > 0) & (abs(t(i)) == 1 / (4*r)) then
        y(i) = (r/sqrt(2)) * ((1+2/%pi)*sin(%pi/(4*r))+(1-2/%pi)*cos(%pi/(4*r)));
    else
        
        
// (4rt)^2 = 1
// <=> 4rt = +/- 1
// <=> t = +/- 1 / 4r

    //printf("r = %f, t = %f, 1 / 4r = %f.\n", r, t, 1/(4*r));
        
    y(i) = (sin(%pi*t(i)*(1-r))+4*r * t(i) .* cos(%pi .* t(i) .* (1+r))) ./ (%pi .* t(i) .* (1-16 * r .* r .* t(i) . * t(i)));
    end;

    end;
endfunction
    
