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

function g = equalizer_zfe(h,n)
// Zero-forcing equalizer (ZFE) FIR filter computation
// 
// Calling Sequence
//   g = equalizer_zfe(h,n)
// 
// Parameters
//  h: Channel filter impulse response
//  n: Number of coefficients to use for the equalization filter
//  g: Output equalization filter coefficients (FIR filter)
// 
// Description
// Given a channel impulse response <latex>$h(z)$</latex>, computes the coefficients of a FIR filter <latex>$g(z)$</latex>, trying to approximate <latex>$g\star h = \delta_d$</latex>, <latex>$d$</latex> being a global delay. That is, g is approximately the inverse filter of h.
// 
// Note: this require to be able to measure the channel impulse response (for instance by sending a dirac-like signal at the emitter side).
//
// <refsection><title>Example</title></refsection>
// <programlisting>
//  // Measured channel response
//  h = [0.1 1 0.2];
//  // Try to compute an inverse FIR filter
//  g = equalizer_zfe(h, 5)
//  // Test the convolution product between g and h: 
//  // this should approximativly be a dirac.
//  convol(g,h)'
// </programlisting>
// 
// See also
//   equalizer_init
//   equalizer_process
// 
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

    h = h(:);
    m = length(h);
    
    if(n < m)
        error("equalizer_zfe(h,n): n must be > to channel length.");
    end;
    
    // (1) Calcule un délais
    // Suppose que h et g sont centrées, delai = m/2 + n/2
    d = round(m/2 + n/2);  
    
    // (2) Construit la matrice de filtrage
    F = zeros(n+m-1,n);
    for i = 0:m-1
        F(i+1,1:i+1) = h(i+1:-1:1)';
    end
    for i = m:n-1
        F(i+1,1+(i+1-m):1+(i+1-m)+(m-1)) = h($:-1:1)';
    end
    for i = n:n+m-1
        for j = 1:m-1-(i-n)
            F(i+1,n-j+1) = h(j+1+(i-n));
        end;
    end
    
    delta = zeros(n+m-1,1);
    delta(d) = 1;
    
    g = F \ delta;
    
endfunction



