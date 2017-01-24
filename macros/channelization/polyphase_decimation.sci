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

function y = polyphase_decimation(x,h,R)
// Apply a FIR filter and decimate the output, using an efficient polyphase structure
//
// Calling Sequence
// y = polyphase_decimation(x,h,R)
//
//  Parameters
//  x: input signal (1d vector)
//  h: FIR filter coefficients (1d vector)
//  R: number of polyphase branches e.g. decimation ratio
//  y: filtered and decimated output
//
//  See also
//   unchannelize
//   channelize
//
// Bibliography
//   F.J. HARRIS, Digital Receivers and Transmitters Using Polyphase Filter Banks for Wireless Communications, 2003
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

    H = polyphase_filter(h,R);
    ntaps = length(h);
    X = polyphase_form(x,R);
    n2 = size(X,2);
    n3 = ceil(n2 + ntaps/R - 1);
    XF = zeros(R,n3);
    for i = 1:R
        XF(i,:) = convol(H(i,:),X(i,:));
    end;
    //n3 = floor(n2 + ntaps/R - 1);
    y = zeros(n3);
    for i = 1:n3
        y(i) = sum(XF(:,i));
    end
endfunction
