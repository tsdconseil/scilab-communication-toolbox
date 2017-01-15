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

function X = polyphase_form(x,M,varargin)
// Creation of the polyphase representation of a signal
//
// Calling Sequence
// X = polyphase_form(x,m);    // Build polyphase matrix
// x = polyphase_form(X,m,-1); // Reverse transform
//
//  Parameters
//  x: 1d signal (1d vector, n elements)
//  M: number of polyphase branches e.g. decimation ratio
//  X: Polyphase matrix (m rows, n/m columns)
//
// Description
// Creation of the polyphase matrix, with zero padding if necessary. First row of X is x(1), x(1+m), x(1+2m), ...,
// second row is x(2), x(2+m), etc.
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

    sens = 1;
    if(argn(2) >= 3)
        sens = varargin(1);
    end;
    
    if (sens == 1)
      x = x(:);
      x = [zeros(M-1,1) ; x]
      n = length(x);
      r = modulo(n,M);
      x = [x ; zeros(M-r,1)];
      n = length(x);
      n2 = n / M; // Nb échantillons par canal
      X = matrix(x,M,n2);
      X = flipdim(X,1);
    else
      X = matrix(x, size(x,1)*size(x,2), 1);
    end;
endfunction
