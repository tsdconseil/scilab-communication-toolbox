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

function y = pam(b,osf,k)
// Pulse Amplitude Modulation (PAM)
//
// Calling Sequence
// x = pam(b,osf,k)
// 
// Parameters
// b: Input binary sequence
// osf: Over-Sampling Factor
// k: Number of bits / symbol
// x: Output signal
// 
// Description
// This function convert a binary sequence (0 and 1) to a sequence
// of number between -1 and 1 (each symbols maps k bits).
// Each symbol is repeated <varname>osf</varname> times (the same as if the
// pulse shaping filter is rectangular / moving average).
//
// See also
//  nrz
//
// Authors
// J.A., full documentation available on...
    
    [lhs,rhs] = argn(0);
    if(rhs == 1) then
        osf = 1;
        k   = 1;
    end;
    if(rhs == 2) then
        k = 1;
    end;
    
    x = symmap(b,k,'b');
    n1 = length(x);
    n2 = n1 * osf;
    y = zeros(n2,1);
    for(i=1:n1)
        y(1+(i-1)*osf:1+(i-1)*osf+osf-1) = x(i);
    end;
endfunction



