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


function y = iqi_simu(s, phi, g)
    // Simulation of I/Q imbalance
    //
    // Calling Sequence
    // y = iqi_simu(x, phi, g)
    //
    // Parameters
    // s: reference signal, without I/Q imbalance
    // phi: Phase mismatch (in radians)
    // g: Relative gain mismatch
    // y: output signal
    // Description
    // I/Q mismatch model:
    // <latex>\begin{align}
    //  Re(y_n) &= s_n \cos(\omega n)\\
    //  Im(y_n) &= g s_n \sin(\omega n+\phi)\\
    //  \end{align}</latex> 
    //
    //
    // Or, equivalently:
    // <latex>$$y_n = \alpha x_n + \beta x_n^\star$$</latex> 
    // where <latex>$x_n$</latex> is the ideal signal (free of imbalance)
    // <latex>$x_n = s_n \cos(\omega n) + \mathbf{i} s_n \sin(\omega n)$</latex>
    // and <latex>$\alpha$</latex> and <latex>$\beta$</latex> are defined as:
    // 
    // <latex>\begin{align}
    //  \alpha &= \frac{1+ge^{-i\phi}}{2}\\
    //  \beta &= \frac{1-ge^{i\phi}}{2}\\
    //  \end{align}</latex> 
    //
    // See also
    //  iqi_blind_est
    //  iqi_cor
    //  iqi_irr
    //
    // Authors
    //  J.A., full documentation available at http://www.tsdconseil.fr/log/sct
    //
    // Bibliography
    // A Low-complexity Feed-forward I/Q Imbalance Compensation Algorithm, N.A. Moseley, http://doc.utwente.nl/66726/1/moseley.pdf
    
    K1 = 0.5 * (1 + g * exp(-%i*phi));
    K2 = 0.5 * (1 - g * exp(%i*phi));
    y = K1 * s + K2 * conj(s);
endfunction




