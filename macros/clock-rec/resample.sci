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


function y = resample(x,R,varargin)
// Resampling at a different frequency
// 
// Calling Sequence
// y = resample(x,R);
// y = resample(x,R,itrp);
//
// Parameters
// x: Input signal (1d vector)
// R: Decimation (R < 1) / upsampling (R > 1) factor, e.g. ratio between the output and input sample frequency.
// itrp: Interpolator object (default is cardinal spline)
// y: Output signal, resampled at input frequency * R
//
// Description
// Time-domain based alternative to native Scilab <link linkend="intdec">intdec</link> function (which is DFT based). 
// The advantages compared to the <varname>intdec</varname> function are:
// <itemizedlist>
//   <listitem><para>No spectral leakages effects due to different values at the beginning and end of the signal,</para></listitem>
//   <listitem><para>Better mastering of the frequency response (aliasing rejection), contrary to DFT method.</para></listitem>
//   <listitem><para>The possibility to choose the interpolation algorithm to use (currently supported: cardinal cubic splines, linear and lagrange).</para></listitem>
// </itemizedlist>
// 
// The default implementation is based on the cardinal cubic spline interpolator.
//
// <refsection><title>Example</title></refsection>
// <programlisting>
// fs1 = 10; fs2 = 100; // Input and output sample rates
// t1 = (0:1/fs1:1)';
// t2 = (0:1/fs2:1)';
// x = t1; // Signal to interpolate
// // Interpolation (intdec VS resample)
// yi = intdec(x, fs2/fs1);
// yr = resample(x, fs2/fs1);
// // Trunk the end of interpolated signals
// yi = yi(1:length(t2)); yr = yr(1:length(t2));
// // Plotting
// clf(); plot(t1,x,'sb'); plot(t2,yi,'r'); plot(t2,yr,'g');
// legend(['1:n';'intdec(1:n,8)';'resample(1:n,8)']);
// </programlisting>
// <mediaobject><imageobject><imagedata fileref="ex_resample.png" format="PNG"/></imageobject><caption><para>Comparison between intdec (DFT based) aand resample (interpolator based)</para></caption></mediaobject>
// 
// Note the importance of the leakage effects in intdec function, due to the hypothesis of periodicity (introducing a big discontinuity between the end and the begin of the signal).
// 
// See also
//  intdec
//  itrp_init
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

    x = x(:);
    if(argn(2) > 2)
      itrp = varargin(1);
    else
      itrp = itrp_init();
    end;
    
    function wnd = update_wnd(wnd, x)
        n = length(wnd);
        for(i=1:n-1)
            wnd(i) = wnd(i+1);
        end;
        wnd(n) = x;
    endfunction
    
    oindex = 1;
    y = [];
    
    wnd = zeros(itrp.nspl,1);
    // Position initiale
    // Il faut sample le premier point :
    //  - à mu = 0
    //  - 
    
    mu = itrp.delay;
    printf("mu0 = %f.\n", mu);
    
    x(length(x)+1) = x(length(x));
    x(length(x)+1) = x(length(x));
    for(i = 1:length(x))
        wnd = update_wnd(wnd, x(i));

        mu = mu - 1;
        
        while(mu < 1)
            
          if(mu < 0) then
              error("mu < 0 !");
          end;

          y(oindex) = itrp.fun(wnd,mu,itrp);
          oindex = oindex + 1;
          mu = mu + 1.0 / R;
        end;
    end;
endfunction

