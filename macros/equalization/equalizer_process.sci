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

function [eq,y,varargout] = equalizer_process(eq,x)
// Equalization of an input signal
// 
// Calling Sequence
// [eq,y] = equalizer_process(eq,x);
// [eq,y,err] = equalizer_process(eq,x);
//
// Parameters
//  eq: equalizer object (see <link linkend="equalizer_init">equalizer_init</link>)
//  x: input signal to be equalized
//  y: output signal
//  err: Error for each symbol
// 
// Description
//  Perform CMA or LMS equalization, using DDE (Decision directed) or DFE (Decision feedback) structure.
//
// <refsection><title>Example</title></refsection>
// <programlisting>
//   fs = 4; fi = 0; fsymb = 1;
//   wf = wf_init('qpsk');
//   eq = equalizer_init(wf, fs/fsymb, 'cma', 'dfe', 0.01,21);
//   h = [1 0.1 -.1 0.15 0.05];
//   mod = mod_init(wf, fs,fi,fsymb);
//  [mod,x] = mod_process(mod,prbs(2000));
//   y = convol(h,x);
//   y = awgn(y, 0.02, 'c');
//   [eq,z] = equalizer_process(eq, y);
// </programlisting>
// <mediaobject><imageobject><imagedata fileref="ex-dfe-cma-const.png" format="PNG"/></imageobject><caption><para>Example: DFE / CMA equalization</para></caption></mediaobject>
// 
// See also
//  equalizer_init
//
// Authors
//  J. Arzi, full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>    


    function [e,d] = calcule_erreur(eq, x)
        if(eq.errf == 'slicer')
            // Différence avec le symbole le plus proche sur la constellation
            d = eq.wf.lookup(x);
            e = d - x;
        elseif(eq.errf == 'cma')
            //e = conj(x) * (eq.g2 - abs(x)^2);
            e = real(x) * (eq.g2 - abs(x)^2);
            //e = x * (eq.g2 - abs(x)^2);
            //e = sign(x) * (1 - abs(x));
            d = eq.wf.lookup(x);
        end;
    endfunction;

    n = length(x);
    x = x(:);
    y = zeros(n);
    err = zeros(y);

    if(eq.structure == 'dde')
      for i = 1:n 
        eq.wnd = [eq.wnd(2:eq.N1) ; x(i)];
        egalise  = sum(eq.h .* eq.wnd);
        //[e,d] = calcule_erreur(eq, egalise);
        d = eq.wf.lookup(egalise);
        if(eq.errf == 'cma')
          e = eq.g2 - abs(egalise)^2;
          eq.h = eq.h + eq.gain * e * real(eq.wnd .* conj(egalise));
        else
          e = d - egalise;
          eq.h = eq.h + eq.gain * real(conj(e) * eq.wnd);
          //eq.h = eq.h + eq.gain * e * eq.wnd;
        end;
        y(i) = egalise;
        err(i) = e;
      end;
    elseif(eq.structure == 'dfe')
      j = 1;
      for i = 1:n
        eq.wnd = [eq.wnd(2:eq.N1) ; x(i)];
        eq.cnt = eq.cnt + 1;
        if(eq.cnt == eq.K)
          eq.cnt = 0;
          retroaction = sum(eq.h_arriere .* eq.wnd_deci);
          egalise  = sum(eq.h_avant .* eq.wnd) + retroaction;
          //[e,d] = calcule_erreur(eq, egalise);
          
          d = eq.wf.lookup(egalise);
          if(eq.errf == 'cma')
            e = eq.g2 - abs(egalise)^2;
            //eq.h = eq.h + eq.gain * e * real(eq.wnd .* conj(egalise));
            eq.h_avant   = eq.h_avant   + eq.gain * e * real(eq.wnd .* conj(egalise));
            eq.h_arriere = eq.h_arriere + eq.gain * e * real(eq.wnd_deci .* conj(egalise));
          else
            e = d - egalise;
            eq.h_avant   = eq.h_avant   + eq.gain * real(conj(e) * eq.wnd);
            eq.h_arriere = eq.h_arriere + eq.gain * real(conj(e) * eq.wnd_deci);
            //eq.h = eq.h + eq.gain * e * eq.wnd;
          end;
          
          //eq.h_avant   = eq.h_avant   + eq.gain * e * eq.wnd;
          //eq.h_arriere = eq.h_arriere + eq.gain * e * eq.wnd_deci;
          y(j) = egalise;
          j = j + 1;
          eq.wnd_deci = [eq.wnd_deci(2:eq.N2) ; d];
          err(i) = e;
       end;
      end;
      y(j:$) = [];
    end;
    if(argn(1) >= 3)
        varargout(1) = err;
    end;
endfunction

