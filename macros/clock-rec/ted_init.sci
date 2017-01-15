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

function ted = ted_init(varargin)
// Creation of a Timing Error Detector (TED)
// Calling Sequence
// ted = ted_init();                // Default is Gardner detector
// ted = ted_init('gardner'[,opt]); // Gardner
// ted = ted_init('mm');            // Mueller and Muller detector
// ted = ted_init('el');            // Early-late detector
// 
// Parameters
// opt: optionnal option for Gardner detector: <varname>'b'</varname> for basic Gardner, <varname>'u'</varname> for upgraded Gardner (insensible to DC offset). If not specified, the ugraded version is selected.
// ted: the timing error detector object
//
// Description
//   A timing error detector is an algorithm that can detect the current clock
//  offset between the received signal and the local sampling clock. The timing error estimation
//  is usually based on the detection of transitions in the received signal. Different estimators
//  are included in the library:
// <itemizedlist>
//   <listitem><para><emphasis role="bold">Gardner detector:</emphasis>
// 
// With 'b' option (basic), compute 
// <latex>$$e_n = (x_{n+1}-x_{n-1})x_n$$</latex>
//
// With 'u' option (upgraded), compute
// <latex>$$e_n = (x_{n+1}-x_{n-1})(x_n-\frac{x_{n-1}+x_{n+1}}{2})$$</latex>
//   </para></listitem>
//   <listitem><para><emphasis role="bold">Mueller and Muller detector:</emphasis>
// 
// Compute 
// <latex>$$e_n = \hat{x}_{n-1}r_{n}-\hat{x}_nr_{n-1}$$</latex>
// with <latex>$r$</latex> = received signal, and <latex>$\hat{x}$</latex> = estimated signal (here sign(r)).
// <para>Restrictions : 
//  <itemizedlist>
//  <listitem>AGC et DC offset correction are necessarily done before.</listitem>
//  <listitem>Needs only 1 sample / symbol.</listitem>
//  </itemizedlist></para>
//   </para></listitem>
//   <listitem><para><emphasis role="bold">Early-late gate detector,</emphasis> 
//     with delay = 1/2 symbol.
// 
//  Compute: <latex>$$e_n = x_{n+1}-x_{n-1}$$</latex>
//   </para></listitem>
// </itemizedlist>
//
// <refsection><title>Example</title></refsection>
// <programlisting>
//   ted = ted_init('mm');
//   plot_scurve(ted);
// </programlisting>
// <imageobject><imagedata fileref="ex_ted_init.png" format="PNG"/></imageobject>
// 
// See also
//  clock_rec_init
//  scurve
//  plot_scurve
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

  strtype = 'gardner';
  if(argn(2) >= 1)
      strtype = varargin(1);
  end;

  select(strtype)
  case 'gardner' then
      if(argn(2) < 2)
        ted = ted_gardner();
      else
        ted = ted_gardner(varargin(2));
      end;
  case 'el' then
      ted = ted_el();
  case 'mm' then
      ted = ted_mm();
  else
      error(sprintf("ted_init(): invalid type : %s"), strtype);
  end;
endfunction



function ted = ted_el()
// Examples
// [tau,s] = scurve(ted_el());
// plot(tau,s);
//
// See also
//  ted_mm
//  ted_gardner
//
// Authors
//  J.A., Full documentation available on www.tsdconseil.fr/log
    function e = detector(x)
      e = -x(2) * (x(3) - x(1))/2;
      //e = (x(1) - x(3))/2;
    endfunction
    
    ted.name  = "early-late";
    // 2 échantillons / symbole
    // A besoin des 3 derniers échantillons
    ted.rythm = 2;
    ted.nspl  = 4;
    ted.fun   = detector;
endfunction


function ted = ted_qpsk()
    function e = detector(x)
      xr = real(x * exp(%i*%pi/4));
      xi = imag(x * exp(%i*%pi/4));
      e1 = (xr(3) - xr(1)) * xr(2) / 2;
      e2 = (xi(3) - xi(1)) * xi(2) / 2;
      e = e1 + e2;
    endfunction
    
    ted.name  = "Gardner - QPSK";
    // 2 échantillons / symbole
    // A besoin des 3 derniers échantillons
    ted.rythm = 2;
    ted.nspl  = 3;
    ted.fun   = detector;
endfunction

function ted = ted_gardner(varargin)
// Gardner timing error detector (ted)
//
// Calling Sequence
//   ted = ted_gardner()
//   ted = ted_gardner(opt = 'b' | 'u')
//
// Parameters
// opt: 'b' for basic Gardner, 'u' for upgraded Gardner (insensible to DC offset)
//
// Description

//
// Examples
// [tau,s] = scurve(ted_gardner());
// plot(tau,s);
//
// See also
//  ted_el
//  ted_mm
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

//
    
    [lhs,rhs] = argn();
    
    opt = 'b';
    if(rhs > 0) then
      opt = varargin(1);
      if(opt <> 'b') & (opt <> 'u') then
          error("ted_gardner : option must be ''b'' (basic) or ''u'' (upgraded).");
      end;
    end;
    
    function e = detector_basic(x)
      e = real((sign(x(3)) - sign(x(1))) * x(2) / 2);
    endfunction
    
    function e = detector_upgraded(x)
      e = real((sign(x(3)) - sign(x(1))) * (x(2) - (x(1)+x(3)) / 2) / 2);
    endfunction
    
    ted.name  = "Gardner";
    // 2 échantillons / symbole
    // A besoin des 3 derniers échantillons
    ted.rythm = 2;
    ted.nspl  = 3;
    ted.fun   = detector_basic;
    
    if(opt == 'u') then
        ted.name = "Gardner - upgraded";
        ted.fun = detector_upgraded;
    end;
endfunction

function ted = ted_mm()
// Mueller and Müller timing error detector (ted)
//
// Calling Sequence
//   ted = ted_mm()
//
// Description

//
// Examples
// [tau,s] = scurve(ted_mm());
// plot(tau,s);
//
// See also
//  ted_el
//  ted_gardner
//
// Authors
//  J.A., Full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

    
    function e = detector(x)
      d = sign(x); // Décision (A FAIRE : appeler un slicer en fonction de la modulation)
      e = -real(d(1) * x(2) - d(2) * x(1)) / 2;
    endfunction
    
    ted.name  = "mm";
    ted.rythm = 1;
    ted.nspl  = 2;
    ted.fun   = detector;
endfunction


