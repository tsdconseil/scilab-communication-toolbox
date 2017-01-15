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

function [g,phi] = iqi_blind_est(x)
    // I/Q imbalance blind estimation
    //
    // Calling Sequence
    // [g,phi] = iqi_blind_est(x)
    // Parameters
    // x: received I/Q signal (complex)
    // g: estimation of gain imbalance
    // phi: estimation of phase imbalance
    // Description
    // Compute I/Q imbalance parameters to fit the model:
    // 
    // <latex>$$x_n = s_n \left(\cos(\omega t) + ig\sin(\omega t + \phi)\right)$$</latex>
    //
    // with <latex>$s_n$</latex> being the the rf signal, g the gain imbalance, and <latex>$\phi$</latex> the phase imbalance.
    // 
    // See a complete example in the documentation of the <link linkend="iqi_cor">iqi_cor</link> function.
    //
    // See also
    //  iqi_cor
    //  iqi_irr
    //  iqi_simu
    // Authors
    //  J.A., full documentation available at http://www.tsdconseil.fr/log/sct
    
    x = x(:);
    
    n = length(x);
    
    I = real(x);
    Q = imag(x);
    
    ei = (I' * I) / n;
    eq = (Q' * Q) / n;
    g = sqrt(eq / ei);
    phi = -asin((Q' * I) / (n * g * ei));
endfunction
