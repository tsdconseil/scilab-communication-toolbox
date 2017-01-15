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

function x=symmap(b,k,varargin)
// Maps a binary sequence to a symbol sequence
// 
// Calling Sequence
// x = symmap(b,k[,enc])
//
// Parameters
// b: Input binary sequence (must be a vector of 0.0 and 1.0)
// k: Number of bits / symbol
// enc: Specify binary ('b', default), phase ('p'), or qam ('q') encoding
// x: Output symbol vector (real or complex)
//
// Description
// Maps a binary sequence (sequence of 0 or 1) to a sequence of symbols, using one of the following possible encodings:
// <itemizedlist>
//   <listitem><emphasis role="bold">Binary encoding (PAM / NRZ)</emphasis> / <varname>enc = 'b'</varname>: produces a vector of real symbols, uniformly distribued between -1 and 1 (if k = 2, only -1 and 1 are produced, e.g. NRZ encoding).</listitem>
// <listitem><emphasis role="bold">Phase encoding (PSK)</emphasis> / <varname>enc = 'p'</varname>: produces complex symbols of unit magnitude and uniformly distribued phase between 0 and <latex>$2\pi$</latex> radians (for k = 1 bit/symbol, this is BPSK, which symbols are identical to NRZ, for k = 2 bits/symbol, this is QPSK, ...).</listitem>
// <listitem><emphasis role="bold">Quadrature amplitude Encoding (QAM)</emphasis> / <varname>enc = 'q'</varname>: produces complex symbols where real and imaginary parts of the signal are independently modulated using each one half of the bitstream.</listitem> 
// </itemizedlist>
//
// <refsection><title>Example</title></refsection>
// <programlisting>
//   x1 = symmap([0 1 0 0], 1, 'b') // NRZ encoding
//   x2 = symmap([0 1 0 0], 2, 'p') // QPSK encoding
// </programlisting>
// 
// See also
//  symdemap
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>    

    enc = 'b';
    if(argn(2) >= 3)
      enc = part(varargin(1),1);
    end;

    if((k == 1) & (enc == 'b'))
        // Plus rapide !
        x = 2 * (b - 0.5);
        return;
    end;

    if(enc == 'g')
        error("symmap: TODO (gray encoding)");
    end;
    if((enc ~= 'b') & (enc ~= 'p') & (enc ~= 'q'))
        error("symmap: encoding must be ''b'', ''g'' or ''pp''.");
    end;
    
    if(enc == 'q')
        if(modulo(k,2) ~= 0)
            error("symmap / QAM mode: k should be multiple of 2.");
        end;
        b1 = b(1:2:$);
        b2 = b(2:2:$);
        x  = symmap(b1,k/2,'b') + %i * symmap(b2,k/2,'b');
        return;
    end;
    
    n = length(b);
    x = zeros(floor(n/k),1);
    for(i = 1:n/k)
        symb = 0;
        e = 1;
        for(j = 1:k)
            symb = symb + e * b((i-1)*k+j);
            e = e * 2;
        end;
        x(i) = symb;
    end;
    if(enc == 'p')
        phase = 2 .* %pi .* x ./ (2^k);
        x = clean(%e .^ (%i*phase));
    else
        K1 = -1;
        K2 = 2 / (2^k-1);
        x = K1 + K2 * x;
    end;
endfunction


