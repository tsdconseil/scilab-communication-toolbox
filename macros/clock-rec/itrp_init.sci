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

function itrp = itrp_init(varargin)
// Initialization of an interpolator object
//
// Calling Sequence
// itrp = itrp_init();
// itrp = itrp_init(type);
// itrp = itrp_init('lagrange', degree);
//
// Parameters
// type: Interpolator type (default is cardinal spline). Can be 'linear', 'cspline' or 'lagrange'.
// degree: Degree of the polynomial for Lagrange interpolation
// itrp: Interpolator object
//
// Description
// This function will create an interpolator object, that can be used either on fixed interpolation points (then use the interpolator with the <link linkend="resample">resample</link> function) or inside a dynamic clock recovery process (use with <link linkend="clock_rec_init">clock_rec_init</link> function).
// 
// Supported interpolation modes are the following:
// <itemizedlist>
//   <listitem><para><emphasis role="bold">Linear</emphasis> (<varname>type = 'linear'</varname>) : Piecewise linear interpolation between each pair of known values (equivalent to Lagrange of degree 1)</para></listitem>
//   <listitem><para><emphasis role="bold">Cardinal spline</emphasis> (<varname>type = 'cspline'</varname>) : Piecewise third degree polynomial between each pair of known values. The polynomials computed here are Catmull-Rom cardinal splines (equivalent to Lagrange of degree 3).</para></listitem>
//   <listitem><para><emphasis role="bold">Lagrange</emphasis> (<varname>type = 'lagrange'</varname>) : Piecewise polynomial interpolation (the degree d is configurable) between each pair of known values. Each polynomial is computed according to the d+1 neareast known values.</para></listitem>
// </itemizedlist>
// For illustration purpose, below is a comparison of the different interpolators with the Runge function :
// 
// <mediaobject><imageobject><imagedata fileref="ex_itrp_init.png" format="PNG"/></imageobject><caption><para>Comparison of different interpolators with the Runge function</para></caption></mediaobject>
// 
// <refsection>
//  <title>Example</title>
// In this example, we use piecewise linear interpolation, with fixed interpolation points.
// <programlisting>
//R = 10; // Interpolation ratio
//itrp = itrp_init('linear');     // Creation of the interpolator
//t1 = (-1:0.2:1)'; x1 = t1 .^ 2; // Before interpolation
//x2 = resample(x1,R,itrp);       // After interpolation
//// Plotting
//plot(t1,x1,'sk');
//t2 = (-1:(0.2/R):1)'; plot(t2,x2(1:length(t2)),'b-');
//legend(['$t^2$','Linear interpolation']);
// </programlisting>
// <mediaobject><imageobject><imagedata fileref="ex_itrp_init_simple.png" format="PNG"/></imageobject><caption><para>Linear interpolation</para></caption></mediaobject>
// </refsection>
// <refsection>
//  <title>How to define a custom interpolator</title>
//  <para>You can also define your own interpolator object, and for it to be compatible with the other functions (<link linkend="resample">resample</link>, <link linkend="clock_rec_init">clock_rec_init</link>), it should be a structure containing the following fields:</para>
// <itemizedlist>
//   <listitem><varname>itrp.name:</varname> name of the interpolator (string)</listitem>
//   <listitem><varname>itrp.nspl:</varname> Number of input sample needed to compute one output sample. For example, for the piecewise linear interpolator, it is 2.</listitem>
//   <listitem><varname>itrp.delay:</varname> Delay, in number of input samples, introduced by the interpolator</listitem>
//   <listitem><varname>itrp.fun:</varname> Interpolating function, which prototype should be: <varname>y = itrp_fun(x,mu,itrp)</varname>, 
//  where x are nspl input samples, mu is the fractionnal delay, itrp the interpolator object, and y the computed output sample.
// </listitem>
// </itemizedlist>
// </refsection>
// 
// See also
//  resample
//  clock_rec_init
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>




function itrp = itrp_cspline()
    // Cardinal cubic splines interpolation
    function y = fun(x,mu,itrp)
      // use c = 0 (Catmull-Rom spline)
      G = itrp_cspline_filter(mu, 0);
      y = sum(x(:) .* G);
    endfunction
    
    itrp.name   = "cardinal spline";
    itrp.nspl   = 4; // needs 4 samples
    itrp.delay  = 3;
    itrp.fun    = fun;
    itrp.filter = itrp_cspline_filter;
endfunction


function LUT = itrp_cspline_lut(n, c)
  // Calcul une LUT
  // Parameters:
  // n:  rapport de sur-échantillonage  
  LUT = zeros(n-1, 4);
  for(i=1:n-1)
    mu = i / n;
    LUT(i,:) = (itrp_cspline_filter(mu, c))';//round(256 * cspline_filter(mu, c));
    LUT(i,:) = LUT(i,:) ./ sum(LUT(i,:));
    //LUT(:,i) = floor(LUT(:,i) * 256.0 / sum(LUT(:,i)));
    //sm(i) = sum(LUT(:,i)/256);
  end;
endfunction;

function itrp = itrp_lagrange(d)
    // Lagrange interpolation
    // Parameters:
    // d: polynomial degree
    function y = fun(x,mu,itrp)
      d = itrp.d;
      // Points: 0 1 2 ... d
      // interpole à (d-1)/2 + mu
      // Exemple: d = 1
      // interpole à mu 
      //t = (d-1) / 2 + mu; // Point d'interpolation
      //t = d - 1 + mu;
      //t = 0.5 + mu;
      t = floor((d-1) / 2) + mu;
      y = 0;
      for(j=0:d)
          idx = 0:d;
          idx(j+1) = [];
          y = y + prod(t-idx) * x(j+1) / prod(j-idx);
      end;
      
      // Exemple: d = 2
      // j = 0,1,2
//      y = (t-1)(t-2) * x(0+1) / (0-1) * (0-2)
//        + (t-0)(t-2) * x(1+1) / (1-0) * (1-2)
//        + (t-0)(t-1) * x(2+1) / (2-0) * (2-1)
      // => y(t=0) = x(0+1)
      // => y(t=1) = x(1+1)
      // => y(t=2) = x(2+1)
      
    endfunction
    
    // Pour un polynome de degré d,
    // on peut passer par d+1 point
    itrp.name  = "Lagrange " + sprintf("degré %d", d);
    itrp.nspl  = d+1; // needs d+1 samples
    itrp.fun   = fun;
    itrp.d     = d;
    itrp.delay = 1 + d - floor((d-1) / 2);
endfunction

function itrp = itrp_lin()
// Linear interpolation

    function y = fun(x,mu,itrp)
      y = x(1) * (1-mu) + x(2) * mu;
    endfunction
    
    itrp.name  = "linear";
    itrp.nspl  = 2; // needs 2 samples
    itrp.fun   = fun;
    itrp.delay  = 2;
endfunction



    if(argn(2) == 0)
        itrp = itrp_cspline();
        return;
    end;
    
    select(varargin(1))
    case 'cspline' then
        itrp = itrp_cspline();
        return;
    case 'linear' then
        itrp = itrp_lin();
    case 'lagrange' then
        if(argn(2) < 2)
            error("Lagrange interpolator: require specification of degree.");
        end;
        d = varargin(2);
        itrp = itrp_lagrange(d);
    else
        error(sprintf("itrp_init: unknown interpolator type ''%s''.", varargin(1)));
    end;
endfunction


// Calcul les coefficient d'interpolation
// pour calculer  p(i+t), connaissant p(i-1),p(i),p(i+1),p(i+2)
// Note : p'(i) et p'(i+1) sont calculés en fonction du paramètre de tension
// fourni (c)
function [G] = itrp_cspline_filter(mu, c)
    // Calcul les coefficient d'interpolation
    // pour calculer p(i+t), connaissant p(i), p'(i), p(i+1), p'(i+1)
    function [H] = cspline_coefs(mu)
      H = zeros(4,1);
      H(1) = (1+2*mu)*(1-mu)*(1-mu); // coef p(i)
      H(2) = mu * (1 - mu) * (1 - mu); // coef p'(i)
      H(3) = mu * mu * (3 - 2*mu); // coef p(i+1)
      H(4) = mu * mu * (mu - 1);  // coef p'(i+1)
    endfunction;
    
  H = cspline_coefs(mu);
  G = zeros(4,1);
  G(1) = - (1-c) * H(2) / 2;
  G(2) = H(1) - (1-c) * H(4) / 2;
  G(3) = H(3) + (1-c) * H(2) / 2;
  G(4) = (1-c) * H(4) / 2;
endfunction;


