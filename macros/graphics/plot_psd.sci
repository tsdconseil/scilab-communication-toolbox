
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

function plot_psd(x,varargin)
// Plot Power Spectral Density (psd)
//
// Calling Sequence
//  plot_psd(x);
//  plot_psd(x,fs[,opt]);
//  plot_psd(x,fs[,opt],fmin,fmax);
//  plot_psd(x,fs[,opt],fmin,fmax,nwin);
//
// Parameters
// x: Input signal (real or complex)
// fs: Input signal sampling rate, in Hz
// opt: String option to be passed to the plot function (like 'r' for a red color)
// fmin: Minimum frequency to display (default is <latex>$-fs/2$</latex> for complex signals, or 0 for real signals)
// fmax: Maximum frequency to display (default is <latex>$fs/2$</latex>)
// 
// Description
// Plot power versus frequency. If the input signal is real, then only
// the positive frequencies are plotted. Otherwise (complex signal), both 
// positive and negative frequencies are displayed.
// 
// Note that this function compute the PSD in a very simple way: it just apply a Hann window before doing the DFT. So, it is just a convenience function to have a quick view at the spectrum of a signal. For more advanced PSD, see the cspect, pspect, ... native functions of SCILAB.
// 
// <refsection><title>Example 1 : PSD of a real signal (pure sinusoid)</title></refsection>
// <programlisting>
//// Sampling rate = 48 kHz, real signal @ 12 kHz
//fs = 48e3; f = 12e3;
//t = (0:1/fs:1)';
//x = sin(2*%pi*f*t);
//clf(); plot_psd(x,fs);
// </programlisting>
// <imageobject><imagedata fileref="ex_plot_psd1.png" format="PNG"/></imageobject>
//
// <refsection><title>Example 2 : PSD of a complex signal (pure exponential)</title></refsection>
// <programlisting>
//// Sampling rate = 48 kHz, complex signal @ 12 kHz
//fs = 48e3; f = 12e3;
//t = (0:1/fs:1)';
//x = exp(2*%pi*%i*f*t);
//clf(); plot_psd(x,fs);
// </programlisting>
// <imageobject><imagedata fileref="ex_plot_psd2.png" format="PNG"/></imageobject>
//
// <refsection><title>Example 3 : PSD of a BPSK signal (with zooming)</title></refsection>
// <programlisting>
// // Plot the PSD of a test BPSK signal (sampled at 1 MHz)
// // and zoom between 100 KHz and 300 KHz
// x = sct_test_signal1();
// plot_psd(x,fs=1e6,fmin=100e3,fmax=300e3);
// </programlisting>
// <imageobject><imagedata fileref="ex_plot_psd3.png" format="PNG"/></imageobject>
// 
// See also
//  plot_psd
//  plot_rimp
//  plot_eye
//  wf_init
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

    rhs = argn(2) - 1;
    fs = 1;
    if(rhs > 0)
        fs = varargin(1);
        rhs = rhs - 1;
    end;
    
    opt = 'b-';
    cnt = 2;
    
    if(rhs > 0)
        if(type(varargin(cnt)) == 10)
          opt = varargin(cnt);
          cnt = cnt + 1;
          rhs = rhs - 1;
        end;
    end;
    
    fmin_specified = %f;
    fmin = -fs/2;
    fmax = fs/2;
    
    if(rhs > 0)
        fmin_specified = %t;
        fmin = varargin(cnt);
        cnt = cnt + 1;
        rhs = rhs - 1;
    end;
    
    if(rhs > 0)
        fmax = varargin(cnt);
        cnt = cnt + 1;
        rhs = rhs - 1;
    end;
    
    nwin = 1;
    if(rhs > 0)
        nwin = varargin(cnt);
        cnt = cnt + 1;
        rhs = rhs - 1;
    end;
    
    x = x(:);
    n = length(x);
    
    if(nwin == 1)
      wnd = window('hn',n)';
      x = x .* wnd;
      X = fftshift(abs(fft(x)));
    else
      
      n2 = n / nwin;
      
      
      
    end     
    
    //fr = linspace(-fs/2,fs/2,n)';
    if(min(X) > 0)
      psd = 20*log10(X);
    else
      psd = 20*log10(X+1e-12);
    end;
    
    if(isreal(x) & ~fmin_specified)
        fmin = 0;
        //fr = linspace(0,fs/2,floor(n/2))';
        //psd = psd($-floor(n/2)+1:$);
    end;
    
    npts = round(n * (fmax - fmin) / fs);
    fr = linspace(fmin, fmax, npts)';
    imin = round(1 + (n-1) * (fmin + fs/2) / fs);
    imax = round(1 + (n-1) * (fmax + fs/2) / fs);
    if(imax-imin+1 > npts)
        imax = npts + imin - 1;
    end;
    imin = min(max(imin,1),n);
    imax = min(max(imax,1),n);
    psd = psd(imin:imax);
    plot(fr(1:length(psd)),psd,opt);
    xtitle('PSD', 'Frequency (Hz)', 'Power (dB)');
endfunction

