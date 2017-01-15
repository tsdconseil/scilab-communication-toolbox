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

function plot_eye(x, T)
// Plot the eye diagram
//
// Calling Sequence
// plot_eye(x, T);
//
// Parameters
// x: input sequence
// T: symbol period (in samples)
// 
// Description
// Plot the eye diagram of a synchronous data signal, which is a scatter plot of the signal where the time domain is considered modulo the symbol period (actually using a trigger on the signal, to account for symbol period variations).
// 
// This diagram is useful to view the impact of ISI (Inter-Symbols Interferences).
// <refsection><title>Example</title></refsection>
// <programlisting>
//T = 128; // Symbol period
//x = nrz(prbs(500),T); // 500 symbols, NRZ shape
//x = ma(x, osf); // moving average
//x = awgn(x, 0.1); // AWGN noise
//clf(); 
//eyediagram(x, T);
// </programlisting>
// <imageobject><imagedata fileref="ex_eyediagram.png" format="PNG"/></imageobject>
//
// See also
//  plot_const
//  plot_psd
//  plot_rimp
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

function tt = trig2(x, T)
    //tt = T/2:T:length(x);

    // Reference signal with pulse @ t = 0    
    n = length(x);
    A = zeros(T,1);
    A(1) = 1;
    ref = repmat(A, n / T, 1);
    
    // Signal with pulses at the transitions
    y = diff(x) .^ 2;
    
    //printf("compute delay...\n");
    delay = round(delay_estim(ref, y));
    delay = 1 + modulo(delay, T);
    tt = delay+T/2:T:length(x);
    //printf("delay = %d.\n", delay);
    
endfunction


    function tt = trig(x, T)
        
        // Il faut trigger sur :
        // front montant ou descendant
        // PB (1) : plusieurs seuils si M-PAM !!!
        // PB (2) : trig inverse si front en fin de slot
        
        // Stratégie : on cherche les points d'horloge par FFT
        // On accumule sur tous les points d'horloge
        
        
    xmin = min(x);
    xmax = max(x);
    seuil = (xmin + xmax) / 2;
    etat = 0;
    n = length(x);
    step = max([floor(T-1),1]);
    tt = [];
    idx = 1;
    idx = find(x < seuil, 1);
    while(idx < n)
       // Etat 0 : recherche de dépassement
       if(x(idx) < seuil)
         idx2 = find(x(idx:$) > seuil, 1);
       else
         idx2 = find(x(idx:$) < seuil, 1);
       end;
       tt = [tt (idx + idx2)];
       idx = idx + idx2 + step;
    end
    endfunction

    //cmap = jetcolormap (100);
    //xset ("colormap",cmap);
    
    x = x(:); // Vecteur colonne
    n = length(x);
    //t = 0:n-1;
    
    //tt = trig(ma(x,T),T)-T/2;
    tt = trig2(x,T);
    tt(find(tt < 1)) = [];
//    x = x(tt(1):$);
//    for(i=1:length(tt)-1)
//        t = tt(i):(tt(i+1)-1);
//        plot(t-tt(i),x(t));
//    end;

    t = zeros(1,n);
    
    nt = zeros(2*T*length(tt),1);
    nx = nt;
    
    for(i=1:length(tt)-1)
        ti = tt(i):(tt(i+1)-1);
        t(ti) = ti-tt(i);
        
        itrv = 1+(i-1)*2*T:i*2*T;
        
        nt(itrv) = (0:2*T-1)';
        if(tt(i)+2*T-1 <= n) then
          nx(itrv) = x(tt(i):(tt(i)+2*T-1));
        else
            nt(1+(i-1)*2*T:$) = [];
            x(1+(i-1)*2*T:$) = [];
            break;
        end;      
    end;
    
    //plot(nt, nx, 'b.');
    
    // Accumulation
    sx = 2*T; sy = floor(sx * 2 / 3);
    img = zeros(sx,sy);
    nt = 1 + uint32(floor(nt*(sx-1)/max(nt)));
    y  = 1 + uint32(floor((sy-1) .* (nx - min(nx)) ./ (max(nx) - min(nx))));
    
    n = length(nt);
    //printf("Calcul img...\n");
    // maintenant on sait que sur des intervalles kT...k+1 T,
    // nt est une simple rampe.
    for(i=1:n)
        // nt(i) = x, ny(i) = y
        img(nt(i),y(i)) = img(nt(i),y(i)) + 1;
    end;
    //printf("ok.\n");
    //xset("colormap",jetcolormap(512));
    xset("colormap",graycolormap(512));
    Sgrayplot(1:sx,1:sy,-img+max(img));
    xtitle("Eye diagram");
endfunction



