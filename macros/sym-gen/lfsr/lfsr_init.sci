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

function lfsr = lfsr_init(deg)
// Initialize a LFSR register object
// Calling Sequence
// lfsr = lfsr_init(deg)
//
// Parameters
// deg: LFSR polynomial degree (from 0 to 15)
// lfsr: Resulting LFSR object (can be used with the function lfsr_process)
//
// Description
// <para>The LFSR register size will be 1 + degree,
// and the polynomial choosen so as to have the longest minimal sequence.</para>
// 
// See also
//   lfsr_process
//
// Bibliography
//   Xilinx xapp-052.pdf (July 7, 1996), page 5
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>
    
function p = lfsr_poly(deg)
    // LFSR polynomial for maximum length sequence
    // (from Xilinx xapp-052, July 7, 1996, page 5)
    
    polys = [0
    0
    1 + %z
    %z^2
    %z^3
    %z^3
    %z^5
    %z^6
    %z^4+%z^5+%z^6
    %z^5
    %z^7
    %z^9
    %z^1+%z^4+%z^6
    %z^1+%z^3+%z^14
    %z^1+%z^3+%z^5
    %z^14
    %z^2+%z^3+%z^5];
    
    if((deg < 0) | (deg > length(polys))) then
        error("lfsr_poly: degree not supported.");
    end;
    
    p = polys(1 + deg) + 1;
endfunction

    
    lfsr.poly = uint32(horner(lfsr_poly(deg),2));
    lfsr.reg  = uint32(hex2dec('fa17'));
    lfsr.deg  = deg;
endfunction





