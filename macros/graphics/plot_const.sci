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

function plot_const(x,varargin)
// Plot a scatter plot or a theorical constellation diagram
//
// Calling Sequence
// plot_const(x)        // Scatter plot view
// plot_const(x,'i')    // Scatter plot view, force identic x and y scale
// plot_const(wf)       // Waveform constellation plot
//
// Parameters
// x: I/Q signal (I is real part, Q is imaginary part) to plot
// wf: waveform object (as can be initialized by <link linkend="wf_init">wf_init</link>)
//
// Description  
//  Plot <latex>$\mathbf{Im}(x) = f\left(\mathbf{Re}(x)\right)$</latex>.
//
// <refsection><title>Example 1: plotting a theorical constellation</title></refsection>
// <programlisting>
//   wf = wf_init('qpsk');
//   clf(); plot_const(wf);
// </programlisting>
// <imageobject><imagedata fileref="ex_plot_const1.png" format="PNG"/></imageobject>
// <refsection><title>Example 2: Scatter plot</title></refsection>
// <programlisting>
//   // Generate a test 8PSK signal, with:
//   // sampling frequency = 1 MHz, zero IF, symbol frequency = 100 kHz
//   fs = 1e6; fi = 0; fsymb = 100e3;
//   mod = mod_init('8psk',fs,fi,fsymb);
//   b = prbs(1000); // Random bit sequence
//   [mod,x] = mod_process(mod,b);
//   x = awgn(x,0.02); // Add some noise
//   clf(); plot_const(x, 'i');
// </programlisting>
// <imageobject><imagedata fileref="ex_plot_const2.png" format="PNG"/></imageobject>
//
// <refsection><title>Limitations</title></refsection>
// Cannot be used in the same figure as other plots (except other plot_const), because of an incompatibility due to the colormap function.
// 
// See also
//  plot_psd
//  plot_rimp
//  plot_eyed
//  wf_init
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

    // Vérifier si x est une modulation
    // Si c'est le cas, afficher tous les symboles possibles
    if(type(x) == 17) // mlist
      mod = x;
      M = mod.M; // taille de l'alphabet
      k = log2(M);
      
      b = zeros(M*k,1);
      for(i = 0:M-1)
        // conversion i en binaire : k bits
        for(j = 0:k-1)
            bt = modulo(floor(i / 2^j),2);
            b(i*k+j+1) = bt;
        end; // for j
      end; // for i
      
      if(mod.linear)
        x = mod.gene_symboles(b);
      else
        x = mod.gene_symboles(b,2);
      end;
      minx = min(real(x));
      maxx = max(real(x));
      miny = min(imag(x));
      maxy = max(imag(x));
      dx = maxx-minx;
      dy = maxy-miny;

      plot(real(x), imag(x), 'ob');
      a = gca();
      //a.title.font_size = tfsize;
      a.data_bounds = [minx-0.1*dx,miny-0.1*dy;maxx+0.1*dx,maxy+0.1*dy];
      xtitle('Constellation', 'I', 'Q');
      return;      
    end; // if (type == 17)
    
    isomode = %f;
    
    
    
    if(argn(2) >= 2)
        
        an = 2;
        
        a2 = varargin(1);
        
        if(type(a2) == 1) & isreal(x) & isreal(a2)
            x = x + %i * a2;
            an = an + 1;
        end;
        
        if(argn(2) >= an)
            isomode = (varargin(an-1) == 'i');
        end;
        
    end;

    sx = 256;
    sy = 256;
    img = zeros(sx,sy);
    n = length(x);
    I = real(x);
    Q = imag(x);
    xmin = min(I);
    ymin = min(Q);
    xmax = max(I);
    ymax = max(Q);
    

    
if(isomode)
    if(xmin < ymin)
        ymin = xmin;
    end;
    if(xmax > ymax)
        ymax = xmax;
    end;
    
    if(median(Q) < ymin + (ymax-ymin) / 5)
        ymin = median(Q) - (ymax-median(Q));
    end;
    
    if(abs(xmin - xmax) < 1e-10)
        xmin = xmin - 1;
        xmax = xmax + 1;
        printf("attention\n");
    end;
    if(abs(ymin - ymax) < 1e-10)
        ymin = ymin - 1;
        ymax = ymax + 1;
        printf("attention\n");
    end;
end;    
    
    rx = 1.0 / (xmax - xmin);
    if(ymax == ymin)
        ry = rx;
    else
      ry = 1.0 / (ymax - ymin);
    end;
    
    for i = 1:n
        x = 1 + (sx-1) * (I(i) - xmin) * rx;
        y = 1 + (sy-1) * (Q(i) - ymin) * ry;
        img(x,y) = img(x,y) + 1;
    end

    //printf("max(img) = %f, min = %f.\n", max(img), min(img));
    
    for y = 1:sy
        for x = 1:sx
            if(img(x,y) > 10)
                img(x,y) = 10;
            end;
        end
    end


    img = -img + max(img);
    img = img ./ max(img);
    
    //img = 1.0 - img;
    //xset("colormap",jetcolormap(512));

    // Ou bien
    xset("colormap",graycolormap(512));
    
    //colorbar(0,1)
    Sgrayplot(linspace(xmin,xmax,sx),linspace(ymin,ymax,sy),img);//,strf="042",zminmax=[0,1]);
    //isoview(xmin,xmax,ymin,ymax);
    xtitle("Scatter plot");
endfunction



