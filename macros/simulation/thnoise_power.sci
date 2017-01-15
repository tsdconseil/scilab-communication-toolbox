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

function [N,Ndb] = thnoise_power(bw, T)
    // Compute thermal noise power
    //
    // Calling Sequence
    // [N,Ndb] = thnoise_power(bandwidth, T)
    // [N,Ndb] = thnoise_power(bandwidth)
    //
    // Parameters
    // bw: Noise bandwidth, in Hz
    // T: Ambiant temperature, in ° Celcius (default is 25 °C)
    // N: Noise power, in W
    // Ndb: Noise power, in dBm (0 dBm = 1 mW)
    //
    // See also
    //  awgn
    //
    // Authors
    //  J.A., full documentation available at http://www.tsdconseil.fr/log/sct
    
    [lhs,rhs] = argn(0);
    if(rhs == 1) then
        T = 25; // 25 °C
    end;
    T = 273.15 + T; // Conversion en Kelvin
    kb = 1.380650e-23; // en Joules
    N   = kb * T * bandwidth; // en W
    Ndb = 10 * log10(N * 1e3); // En dbm (0 dbm = 1 mW)
endfunction

