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


function Y = unchannelize(x,h,m)
// Extract m channels (with identical bandwidth) using a polyphase filter bank and FFT (Harris method).
//
// Calling Sequence
// Y = unchannelize(x,h,m)
//
//  Parameters
//  x: input signal, 1d vector
//  h: FIR filter coefficients (low pass channel filter), 1d vector
//  m: number of channels e.g. decimation ratio
//  Y: Output matrix, with one row for each output channel.
//
// Description
// The different channels must be located at (normalized) frequencies of 0, 1/m, ..., (m-1)/m.
// For other cases, see the reference cited in the bibliography.
//
// Bibliography
// Digital Receivers and Transmitters Using Polyphase Filter Banks for Wireless Communications, F.J. Harris, 2003
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>
//

    // (1) polyphase partition of the filter
    H = polyphase_filter(h,m);

    // (2) polyphase partition of the signal
    // On suppose qu'on a un bloc de nchn échantillons
    // A partir du signal d'entrée de n échantillons,
    // on forme nchn signaux de n / nchn échantillons    
    X = polyphase_form(x,m);
    // Chaque ligne de X peut être traitée séparément
    
    
    // (3) Sortie du filtre polyphase
    n2 = size(X,2);
    n3 = n2 + length(h)/m - 1;
    XF = zeros(m,n3);
    for i = 1:m
        XF(i,:) = convol(H(i,:),X(i,:));
    end;
    
    // (4) DFT
    Y = fft(XF,-1,1); // FFT suivant les colonnes (dim n°1)
endfunction
