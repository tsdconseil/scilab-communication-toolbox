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

function b = symdemap(x,k,varargin)
// Maps a symbol sequence to a binary sequence with binary or gray decoding
// 
// Calling Sequence
// b = symdemap(x,k[,enc])
//
// Parameters
// x: Input symbol vector (real or complex, depending on the encoding)
// k: Number of bits / symbol
// enc: Specify binary ('b', default), qam ('q'), or phase ('p') encoding
// b: Output binary sequence (a vector of 0 and 1)
//
// Description
// Maps a symbol sequence to a binary sequence (sequence of 0 or 1), using one of the following possible encodings:
// <itemizedlist>
//   <listitem><emphasis role="bold">Binary encoding (PAM / NRZ)</emphasis> / <varname>enc = 'b'</varname>: produces a vector of real symbols, uniformly distribued between -1 and 1 (if k = 2, only -1 and 1 are produced, e.g. NRZ encoding).</listitem>
// <listitem><emphasis role="bold">Phase encoding (PSK)</emphasis> / <varname>enc = 'p'</varname>: produces complex symbols of unit magnitude and uniformly distribued phase between 0 and <latex>$2\pi$</latex> radians (for k = 1 bit/symbol, this is BPSK, which symbols are identical to NRZ, for k = 2 bits/symbol, this is QPSK, ...).</listitem>
// <listitem><emphasis role="bold">Quadrature amplitude Encoding (QAM)</emphasis> / <varname>enc = 'q'</varname>: produces complex symbols where real and imaginary parts of the signal are independently modulated using each one half of the bitstream.</listitem> 
// </itemizedlist>
//
// <refsection><title>Example</title></refsection>
// <programlisting>
//   b = symdemap([-1 1 1 -1], 1, 'b') // NRZ decoding
// </programlisting>
// 
// See also
//  symmap
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>    
    
    enc = 'b';
    if(argn(2) >= 3)
      enc = part(varargin(1),1);
    end;
    
    if(enc == 'g')
        error("symdemap: TODO (gray encoding)");
    end;
    if((enc ~= 'b') & (enc ~= 'p') & (enc ~= 'q'))
        error("symdemap: encoding must be ''b'', ''g'' or ''pp''.");
    end;
    
    if(enc == 'p')
      x = atan(imag(x),real(x));
      x = round(x .* (2^k) ./ (2 * %pi));
      x = modulo(2^k+x, 2^k);
    elseif(enc == 'q')
      if(modulo(k,2) ~= 0)
        error("symdemap / QAM mode: k should be multiple of 2.");
      end;
      b1 = symdemap(real(x), k/2, 'b');
      b2 = symdemap(imag(x), k/2, 'b');
      // TODO: à vectoriser
      for(i=1:length(b1))
          b(2*(i-1)+1) = b1(i);
          b(2*(i-1)+2) = b2(i);
      end;
      return;
    else
      K1 = -1;
      K2 = 2 / (2^k-1);
      x = (x - K1) ./ K2;
    end;
    
    // Map to binary sequence
    n = length(x);
    b = zeros(n*k,1);
    x = modulo(2^k+round(real(x)), 2^k);
    for i = 1:n
        for j = 1:k
            if(bitand(x(i),2^(j-1)))
                b((i-1)*k+j) = 1;
            end;
        end;
    end
    
endfunction
