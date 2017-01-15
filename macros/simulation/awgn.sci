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

function y = awgn(x,sigma,varargin)
// Simulation of channel with Additive White Gaussian Noise (AWGN)
//
// Calling Sequence
//   y = awgn(x,sigma)      // Real noise if x is real, complex otherwise
//   y = awgn(x,sigma,'r')  // Real noise
//   y = awgn(x,sigma,'c')  // Complex noise
//
// Parameters
// x: input signal
// sigma: square root of noise power
//
// Description
// Compute <latex>$y = x + n$</latex>, with <latex>$n: N(0,\sigma)$</latex>.
// If x is a complex signal, or if complex noise is specifically specified,
// then noise (with same energy) is also added on the imaginary axis.
// So be carefull, with complex noise, the noise power is two times more than for real noise.
//
// Examples
// x = nrz(ts01(10),4);
// y = awgn(x,0.1);
// plot(x,'b'); plot(y,'g');
//
// See also
//  thnoise_power
//  chn_simu
//  fading_chn_init
//
// Authors
//  J.A., full documentation available at http://www.tsdconseil.fr/log/sct
//
    [lhs,rhs] = argn(0);
    opt = 'r';
    if(~isreal(x))
        opt = 'c';
    end;
    if(rhs >= 3)
        opt = varargin(1);
    end;

    y = x + sigma * rand(size(x,1),size(x,2),'normal');
    
    if(opt == 'c')
        y = y + %i * sigma * rand(size(x,1),size(x,2),'normal');
    end;
    
endfunction
