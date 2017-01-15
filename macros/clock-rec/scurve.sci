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

function [tau,s] = scurve(ted, varargin)
// Compute the S-curve of a Timing Error Detector (ted)
//
// Calling Sequence
//   [tau,s] = scurve(ted[, mode = 's' | 'gain' | 'dc'])
//
// Parameters
// ted: timing error detector object
// mode: 's' for standard S-curve, 'gain' for S-curve with input gain perturbation, or 'dc' for S-curve with input-offset perturbation. 
//
// Description
// Compute the S-curve of the specified TED, e.g. ted = f(tau)
//
// Examples
// [tau,s] = scurve(ted_init('gardner'));
// plot(tau,s);
//
// See also
//  ted_init
//  plot_scurve
//
// Authors
//  J.A., full documentation available at http://www.tsdconseil.fr/log/sct
//

    [lhs,rhs] = argn(0);
    
    mode = 's';
    if(rhs >= 2) then
        mode = varargin(1);
    end;
    
    osf = 256;
    x = nrz([0 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1], osf);
    y = ma(x,osf);
    
    //tau = -osf/4:osf/4;
    tau = -(osf-1):(osf-1);
    s = zeros(1,length(tau));
    K2 = ted.rythm;
    nspl = ted.nspl;
    
    for(i = 1:length(tau))

      t = tau(i);
      
      // x doit être un tableau
      vals = zeros(1,nspl);
        
      for(j=1:nspl)
        vals(nspl-j+1) = y(4*osf+t-(j-1)*osf/K2);
      end;
     
      if(mode == 'dc') then   
        s(i) = ted.fun(vals+0.1);
      elseif(mode == 'gain')
        s(i) = ted.fun(vals*1.2);
      else
        s(i) = ted.fun(vals);
      end;
    end;
    tau = tau ./ osf;
endfunction


