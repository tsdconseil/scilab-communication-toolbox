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

function y = frac_delay(x, delay, varargin)
// Fractionnal (sub-sample accuracy) delaying of a signal
// Calling Sequence
// y = frac_delay(x, delay)
// y = frac_delay(x, delay, method = 'itrp' | 'dft')
// y = frac_delay(x, delay, itrp)
//
// Parameters
// x: Input signal
// delay: Delay to apply (expressed in samples, not necessarily an integer)
// method: Specify the method to use: interpolator based ('itrp', default method) or DFT based ('dft')  
// itrp: Interpolator object (see <link linkend="itrp_init">itrp_init</link>)
// y: Output signal, delayed version of x
//
// Description
// The <emphasis role="bold">DFT method</emphasis> is based on the fact that a delay in the time domain is the same as a 
// modulation in the frequency domain:
// 
//  <latex>$$x(t+\tau)\Leftrightarrow X(k)\cdot e^{-\mathbf{i}2\pi\tau \frac{k}{N}}$$</latex>
//
// However, since it is based on the DFT, if the input signal is not periodic, leakages related side effects can occur (see comparison below).
//
// The <emphasis role="bold">interpolator method</emphasis> is based on a cubic cardinal spline interpolator.
// 
// <refsection><title>Example</title></refsection>
// <programlisting>
//t = (0:1/20:1)';
//x = sin(4*%pi*t);
//y = frac_delay(x, 0.5); // Delay by 1/2 sample
//clf(); plot([x y]);
// </programlisting>
// <mediaobject><imageobject><imagedata fileref="ex_frac_delay.png" format="PNG"/></imageobject><caption><para>Example of fractionnal delay</para></caption></mediaobject> 
//
// <refsection><title>Comparison of the two available methods</title></refsection>
// <mediaobject><imageobject><imagedata fileref="ex_frac_delay_comp.png" format="PNG"/></imageobject><caption><para>Comparison between DFT and interpolator based fractionnal delay</para></caption></mediaobject>
// <para>As one can see, the DFT method has some ringing at the end of the signal ; this is due to spectral leakages introduced by the fact that the signal values are different at the begin and at the end (the DFT suppose that the signal is peridic).</para>
//
// See also
// delay_estim
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

  meth = 'i';
  if(argn(2) > 2)
      meth = varargin(1);
  end;
  
  itrp = itrp_init();
  
  if(type(meth) == 17)
      itrp = meth;
      meth = 'i';
  elseif (type(meth) == 10)
      
     meth = part(meth,1);
  
     if((meth ~= 'i') & (meth ~= 'd'))
        error(sprintf("frac_delay: unsupported method ''%s'' (should be ''itrp'' or ''dft'').", meth));
     end;
      
  else
      error("frac_delay: method should be a string or an interpolator structure.");
  end;
  


  x = x(:);
  
  // Applique un délais entier
  if((delay > 0) & (floor(delay) ~= 0))
      x = [zeros(floor(delay), 1) ; x];
      delay = delay - floor(delay);
  end;
  if((delay < 0) & (ceil(delay) ~= 0))
      x = x(-ceil(delay):$);
      delay = delay - ceil(delay);
  end;
  
  if(meth == 'd')
      ////////////////////////
      /// DFT based method
      ////////////////////////
      n = 2 * length(x);
    
      // (1) Padd x with zeroes at begin and end
      x2 = zeros(n,1);
      x2(n/4:n/4+n/2-1) = x;
    
      // A delay in time domain is a modulation in frequency domain
      X = fft(x2);  
      pas = [0:n/2-1 -n/2:-1]';
      
      X = X .* exp(-%i .* delay .* 2 .* %pi .* pas ./ n);
      
      //X = X .* exp(-%i .* delay .* 2 .* %pi .* (0:n-1)' ./ n);
      y2 = ifft(X);
    
      // Now depadd
      y = y2(n/4:n/4+n/2-1);
      
      if(isreal(x))
          y = real(y);
      end;
   else
      ////////////////////////
      /// Interpolator based method
      ////////////////////////
    function wnd = update_wnd(wnd, x)
        n = length(wnd);
        for(i=1:n-1)
            wnd(i) = wnd(i+1);
        end;
        wnd(n) = x;
    endfunction
    
    //printf("Delais résiduel: %f.\n", delay);
    
    oindex = 1;
    y = zeros(length(x), 1);
    //('linear');//('lagrange',5);
    wnd = zeros(itrp.nspl,1);    
    x(length(x)+1) = x(length(x));
    x(length(x)+1) = x(length(x));
    for(i = 1:length(x))
        wnd = update_wnd(wnd, x(i));
        y(i) = itrp.fun(wnd,1-delay,itrp);
    end;
    y = y(itrp.delay:$);
   end;
endfunction

function [a,b] = pad(a,b)
    a = a(:);
    b = b(:);
    la = length(a);
    lb = length(b);
    if(lb > la)
      b = b(1:$-(lb-la));
      //a = [a ; zeros(lb-la,1)];
    elseif(la > lb)
      a = a(1:$-(la-lb));
      //b = [b ; zeros(la-lb,1)];
    end;
endfunction



