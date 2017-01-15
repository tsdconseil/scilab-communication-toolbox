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

function y = iqi_cor(x, g, phi)
    // I/Q imbalance correction
    //
    // Calling Sequence
    // y = iqi_cor(x, g, phi)
    //
    // Parameters
    // x: Input I/Q signal (complex vector)
    // g: Gain relative imbalance
    // phi: Phase imbalance (in radians)
    // y: Output I/Q signal, with imbalance corrected
    // 
    // Description
    // Fix the phase and amplitude imbalance of the received I/Q signal (x is complex).
    // g and phi can be estimated (blind estimation) with the function iq_blind_est.
    // <programlisting>
    // // Generation of a QAM16 signal  (with IF = 0)
    // mod = mod_init('qam16',1000,0,50);
    // [mod,x] = mod_process(mod,prbs(5000));
    // x = awgn(x,0.02,'c'); // noise simulation
    // scf(0); clf(); 
    // subplot(131); plot_const(x); xtitle("Without imbalance");
    // ;
    // // I/Q imbalance simulation
    // x = iqi_simu(x,%pi/10,1.3);
    // subplot(132); plot_const(x); xtitle("With imbalance");
    // ;
    // // I/Q imbalance detection
    // [g,phi] = iqi_blind_est(x);
    // ;
    // // I/Q imbalance correction
    // x = iqi_cor(x,g,phi);
    // subplot(133); plot_const(x); xtitle("Imbalance detected and corrected");
    // </programlisting>
    // <imageobject><imagedata fileref="ex_iqimbalance.png" format="PNG"/></imageobject>
    //
    // See also
    //   iqi_blind_est
    //   iqi_irr
    //   iqi_simu
    // Authors
    //  J.A., full documentation available at http://www.tsdconseil.fr/log/sct
    
    y = real(x) + %i * (real(x) * tan(phi) + imag(x) / (g * cos(phi))); 
endfunction
