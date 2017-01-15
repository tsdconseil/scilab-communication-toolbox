// Scilab Communication Toolbox / carrier_rec_init.sci
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

function cr = carrier_rec_init(ped, lf)
// Initialization of a carrier recovery loop object
//
// Calling Sequence
// cr = carrier_rec_init(ped[, lf])
//
// Parameters
// ped: phase error detector object
// lf: loop filter object (if not specified, the default is a first order loop, with time constant of 10 samples)
//
// Description
// Initialize a carrier recovery loop, using a given Phase Error Detector (ped) and Loop Filter (lf). For example, so a to recover the carrier of a BPSK signal, one can use <link linkend="ped_psk">ped_psk</link> as a phase error detector, and <link linkend="lf_init">lf_init</link> (first or second order loop) as a loop filter.
//
// See also
//  carrier_rec_process
//  lf_init
//  ped_psk
//
// Authors
//  J.A., software published under CeCILL-C license (open source), full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>    
//
//



    cr.lf    = lf;
    cr.ped   = ped;
    cr.theta = 0;
    if(isfield(ped, 'tc'))
      cr.g     = iir1_design('tc', ped.tc);
      cr.rssi  = 1;
    end;
endfunction
