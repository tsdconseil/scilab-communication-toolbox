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

function dt = delay_estim(x0, x1)
// Accurate fractionnal delay estimation between two signals
//
// Calling Sequence
// dt = delay_estim(x0, x1)
//
// Parameters
// x0: first signal
// x1: second signal
// dt: fractionnal delay, in samples
//
// Description
// This function will try to estimate accurately the delay between two signals (sub-sample accuracy). The method consists in (see detail in the reference below): (1) standard coarse delay estimation (based on the correlation of the two signals), (2) line fitting of the residual phase (in the frequency domain) after coarse alignment of the 2 signals.
//
// <refsection><title>Example</title></refsection>
// <programlisting>
//// Test function
//function x = f(t)
//    x = sin(2*%pi*t*10);
//endfunction
//;
//fs  = 1000;         // Sampling rate
//delay = 0.4;        // Delay between the 2 signals, in samples
//t = (0:(1/fs):1)';  // Time vector
//x1 = f(t);          // Signal n°=1
//x2 = f(t-delay/fs); // Signal n°=2, delayed by 0.4 sample
//;
//// Test delay estimation
//d = delay_estim(x1,x2);
//printf("True delay = %f, detected delay = %f.\nError = %e.\n", delay, d, d - delay);
// </programlisting>
//
// See also
//  frac_delay
// 
// Bibliography
//  <emphasis>Subsample time delay estimations based on weighted straight line fitting to cross-spectrum phase</emphasis>, Y. BAI, 2010, <ulink url="http://www.tech-ex.com/article_images3/7/484637/34.pdf">http://www.tech-ex.com/article_images3/7/484637/34.pdf</ulink>
// 
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>    
    
    n0 = length(x0);
    n1 = length(x1);
    
    x0 = x0(:);
    x1 = x1(:);
    
    // (1) Cross-correlation to retrieve 
    // the integer part of delay
    cor = xcorr(x0, x1);
    [unused,ipart] = max(abs(cor));
    ipart = ipart - 1; // Zero-based index
    // Negative lags
    if(ipart >= n0 / 2)
      ipart = -(n0 - ipart);
    end;
    
  // (2) Shift x1 by ipart ==> x2
    x2 = zeros(n0,1);
    
    // on veut : x2(i) = x1(i - ipart)
    // => 1 + ipart <= i <= n1 + ipart
    imin = max(1,1+ipart);
    imax = min(n0,n1+ipart);
    
    x2(imin:imax) = x1(imin-ipart:imax-ipart);  
//  for i = 0:n-1
//    i2 = i - ipart;
//    if((i2 >= 0) & (i2 < n1))
//      x2(i+1) = x1(i2+1);
//    else
//      x2(i+1) = 0;
//    end
//  end

  // (3) Compute the slope
  // (3-1) Compute Real FFT on x0 and x1
  X0 = fft(x0);
  X2 = fft(x2);

  X3 = X0 .* conj(X2);
  
  //printf("cD...\n");
  // (2) Compute D
  D = 0; S = 0;
  for i = 1:n0/2
    mag = norm(X3(i));
    arg = atan(imag(X3(i)),real(X3(i)));
    D = D + (i-1) * arg * mag;
    S = S + mag * (i-1)^2;
  end;
  
  if(S == 0)
    dt = -ipart;
  else
    D = - (D / S) * n0 / (2 * %pi);
    dt = -(D + ipart);
  end;
  
  //printf("ipart = %d, D = %f.\n", ipart, D);
endfunction
