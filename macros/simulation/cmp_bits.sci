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

function [b1,b2,varargout] = cmp_bits(b1,b2,varargin)
// Alignment of 2 bits vectors and counting the number of errors
//
// Calling Sequence
// [b1,b2[,nerr,ber]] = cmp_bits(b1,b2);
// [b1,b2[,nerr,ber]] = cmp_bits(b1,b2,'p',k); // Try to solve phase ambiguity (2^k-PSK)
//
// Parameters
// b1: First bits vector (as output: realigned with b2)
// b2: Second bits vector (as output: realigned with b1)
// nerr: Number of errors (in bits) between the 2 realigned vectors
// ber: Bit Error Rate
//
// Description  
//  Try to find the best correlation between the 2 bit vectors and 
//  count the number of errors (ignoring the 2 first bits and 2 last bits).
//
// <refsection><title>Example</title></refsection>
// <programlisting>
//  b1 = [0 1 0 0 0 1];
//  b2 =   [1 0 0 0 1];
//  [b1,b2,nerr,ber] = cmp_bits(b1,b2);
// </programlisting>
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

function [b1,b2,nerrs] = ambig_try(b1,b2,i,k)
  [b1,b2] = pad(b1,b2);
  x = symmap(b2, k, 'p') * exp(2*%pi*%i*(i-1)/(2^k));
  b2 = symdemap(x, k, 'p');
  [b1,b2,nerrs] = cmp_bits(b1,b2);
endfunction

  if(argn(2) > 2)
      k = varargin(2);
      vnerrs = zeros(2^k, 1);
      for i = 1:2^k
        [b1t,b2t,n] = ambig_try(b1,b2,i,k);
        vnerrs(i) = n;
      end

      [nerrs,i] = min(vnerrs);
      [b1,b2,nerr] = ambig_try(b1,b2,i,k);
      return;
  end;
  
  
  b1 = b1(:);
  b2 = b2(:);
  dt = delay_estim(b1,b2);
  dt = -round(dt);
  if(dt > 0)
    b2 = [zeros(dt,1) ; b2];
  else
    b2 = b2(-dt+1:$);
  end;
  [b1,b2] = pad(b1,b2);
  
  varargout = list();
  
  if(argn(1) >= 3)
      nerr = sum(abs(b1-b2));
      varargout(1) = nerr;
  end;
  
  if(argn(1) >= 4)
      if(length(b2) == 0)
         ber = %nan;
      else
         ber = nerr / length(b2);
      end;
      varargout(2) = ber;
  end;

endfunction;
