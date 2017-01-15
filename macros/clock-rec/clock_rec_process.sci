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

function [cr,y,varargout] = clock_rec_process(cr,x,varargin)
// Proceed to clock recovery. Output signal y is resampled at symbol frequency and synchronized with the detected clock.
// 
// Calling Sequence
// [cr,y] = clock_rec_process(cr,x[,coarse_rssi]);
// [cr,y,dbg] = clock_rec_process(cr,x[,coarse_rssi]);
//
// Parameters
// x: Input signal, sampled at <varname>osf</varname> sample/symbol
// cr: Clock recovery object (can be created with <link linkend="clock_rec_init">clock_rec_init()</link>)
// coarse_rssi: Optionnal vector, of same dimension as x, indicating the coarse RSSI indicator on the x signal. It will be used to normalize the gain on the timing error detection. If not provided, the signal is supposed to be already normalized.
// y: Output signal, synchronized and sampled at 1 sample/symbol
// dbg: Optionnal debug structure (dbg.e: instantaneous clock error (1d vector), dbg.mu: phase shift vector)
//
// Description
// Given an input oversampled binary signal, this function will downsample
// the signal at the symbol rate, and synchronize the sampling points with
// the signal clock.
//
// <refsection><title>Example</title></refsection>
// <programlisting>
//nsymb = 120; // Generate 120 symbols
//osf = 9;     // Input oversampling factor = 9 samples / symbol
//// Creation of a simple signal: NRZ filtered by its matched filter
//// (e.g. a moving average)
//x = ma(nrz(prbs(nsymb),osf),osf);
//// Apply a fractionnal delay so as to have a desynchronized signal
//// (otherwise the signal would be already synchronized)
//x = frac_delay(x, osf/2);
//// Proceed to clock recovery
//cr = clock_rec_init(osf);
//[cr,y] = clock_rec_process(cr,x);
//// --> y is now sampled at one sample / symbol and synchronized
/////////
///////// PLOTTING THE RESULTS
//scf(0); clf();
//// Initial sampling points
// subplot(211); plot(x);
//// Resampled output
// subplot(212); plot(y);
// </programlisting>
// <mediaobject><imageobject><imagedata fileref="ex_clock_rec_process.png" format="PNG"/></imageobject><caption><para>Example of clock recovery</para></caption></mediaobject>
//
// See also
//  clock_rec_init
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>
    
    function wnd = update_wnd(wnd, x)
        n = length(wnd);
        for(i=1:n-1)
            wnd(i) = wnd(i+1);
        end;
        wnd(n) = x;
    endfunction
    
    oindex = 1;
    y = [];
    
    // 3 fréquences différentes :
    // F d'entrée
    // F de fonctionnement du TED
    // F de sortie
    
    // Fréquence de base = Fsymbole (1 Hz)
    // Fréquence d'entrée : osf * Fsymbole
    // Fréquence de travail de la TED : K2 * Fsymbole
    
    E   = [];
    MU  = [];
    DEC = [];
    
    coarse_rssi = ones(x);
    
    if(argn(2) > 2)
        coarse_rssi = varargin(1);
    end;
    
    if(length(coarse_rssi) ~= length(x))
      error("clock_rec_process: x and coarse_rssi must be of the same length.");
    end;
    
    for(i = 1:length(x))
        cr.wnd_x = update_wnd(cr.wnd_x, x(i));
        
        // Requiert: mu >= 1
        
        cr.phase = cr.phase - 1;
        
        if(cr.phase <= 1) then
          
          // Requiert: mu >= 0
          if(cr.phase < 0) then
              error("clock_rec_process: mu < 0!");
          end;
            
          // Ici on est à la fréquence de la TED
          
          //MU = [MU ; cr.mu];
          
          interpol = cr.itrp.fun(cr.wnd_x,cr.phase,cr.itrp);
          cr.phase = cr.phase + cr.osf / cr.K2; // Lecture au rythme de la TED
          cr.wnd_ted = update_wnd(cr.wnd_ted, interpol);

          if(cr.cnt == cr.K2 - 1) then
              y(oindex) = interpol;//cr.wnd_ted(2);//interpol;
              oindex = oindex + 1;
              
              // Appele pas la TED à chaque fois
              // (au même rythme que les éch. de sortie)
              e = cr.ted.fun(cr.wnd_ted  ./ coarse_rssi(i));

              // Filtre IIR du premier ordre
              // mu est exprimé en : nombre de samples d'entrée
              // e : en multiple de la période symbole
              dec = cr.gain * (e * cr.osf);
              
              // Décalage maximum = 0.25 symboles
              dec = max(min(dec, cr.osf/4),-cr.osf/4);
              
              cr.phase = cr.phase - dec;
              cr.e = e;
              E = [E ; e];
              MU = [MU; cr.phase];
              DEC = [DEC; dec];
          end;
          
          cr.cnt = modulo(cr.cnt + 1, cr.K2);
          //if(cr.cnt == cr.K2) then
          //    cr.cnt = 0;
          //end;
        end;
        
    end;
    cr = cr;
    if(argn(1) > 2)
        dbg.e   = E;
        dbg.mu  = MU;
        dbg.dec = DEC;
        varargout = list(dbg);
    end;
endfunction
