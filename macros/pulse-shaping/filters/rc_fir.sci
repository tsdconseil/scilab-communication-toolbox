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

function [h]=rc_fir(r,osf,n,varargin)
// FIR approximation of raised cosine filter
// Parameters
// beta: rool-off factor
// osf: over sampling factor
// n: number of coefficients of the FIR filter
//
// Calling Sequence
//   y = rc_fir(r,osf,n)
//   y = rc_fir(r,osf,n,'sum')     Normalize the coefficients to have sum = 1 (default behavior)
//   y = rc_fir(r,osf,n,'energy')  Normalize the coefficients to preserve energy : <latex>$\sum_i(h_i^2) = 1$</latex>
//
// Description
//
// Examples
// h = rc_fir(r=0.5,osf=2,n=5);
// plot_rimp(h);
//
// See also
//  rc_pulse
//  srrc_pulse
//  srrc_fir
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>
//
// Bibliography
//  Multirate signal processing for communication systems, F.J. Harris, page 89.

    [lhs,rhs] = argn();
    
    nrm = 's';
    if(rhs >= 4) then
        nrm = part(varargin(1),1);
    end;
    
    // n odd
    // ex n = 3 --> -1 0 1
    // n even
    // ex n = 4 --> -1.5, -0.5, 0.5, 1.5 ????
    t = (-(n-1)/2:1:(n-1)/2) ./ osf;
    h = rc_pulse(t,r);
    if(nrm == 'e') then
        for(i=1:size(h,1))
        h(i,:) = h(i,:) ./ sqrt(h(i,:) * h(i,:)'); // h = vecteur ligne
        end;
    else
        for(i=1:size(h,1))
            h(i,:) = h(i,:) ./ sum(h(i,:));
        end;
    end;
endfunction;
