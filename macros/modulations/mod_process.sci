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

function [mod,x,varargout] = mod_process(mod,b)
// Modulation (binary vector to RF or IF output)
// 
// Calling Sequence
// [mod,x] = mod_process(mod,b)
// 
// Parameters
//  mod: Modulation object (created with mod_init(...))
//  b: Input binary vector
//  x: Output IF or RF signal
// 
// Description
//  Code the binary signal using the configured waveform (BPSK, FSK, ...) and then
//  upconvert to IF or RF frequency. If the specified IF frequency is not null, remove also
//  the imaginary part of the signal (output signal is real).
//
// <refsection><title>Example</title></refsection>
// <programlisting>
//// FSK modulator, sampling frequency = 1 MHz, IF = 50 KHz, FSYMB = 20 KHz
//wf = wf_init('fsk',M=2,index=2.0);
//mod = mod_init(wf, fs = 1e6, fi = 50e3, fsymb = 20e3);
//// Random sequence of 20 bits
//b = prbs(20);
//// Modulation
//[mod,x] = mod_process(mod,b);
//clf(); plot(x);
// </programlisting>
// <mediaobject><imageobject><imagedata fileref="ex_mod_process.png" format="PNG"/></imageobject><caption><para>Using mod_process to modulate a FSK signal</para></caption></mediaobject>
//
// See also
//  mod_init
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>
    
    if(argn(1) < 2)
        error("mod_process: at least two output arguments are required: [mod,x].");
    end;
    
    // Si modulation FSK :
    //  (1) Géné symboles (dép. modulaiton)
    //  (2) Upsampling et filtrage
    //  (3) Conversion phase -> IQ
    //  (4) Modulation RF
    // Si modulation linéaire :
    //  => (1) Géné symboles (dép. modulation)
    //     (2) Upsampling et filtrage
    //     (3) Modulation RF
    
    
    x = mod.wf.gene_symboles(b);
    // Filtre de mise en forme
    x = upsample(x, mod.ovs);
    [mod.psf,x] = psfilter_process(mod.psf,x);
    x = x .* mod.ovs;
    
    if(mod.wf.is_fsk)
        // h = 2 fd / fsymb = excursion / fsymb
        // => omega_max = 2%pi*fd = %pi * h * fsymb
        // => Omega_max = omega_max / fs
        //              = %pi * h / ovs;
        // Conversion phase -> IQ
        dbg.x0 = x;
        omega_max = %pi * mod.wf.index / mod.ovs;
        // normalisation entre [-fmax,fmax]
        vfreqs = x .* omega_max ./ max(x);
        vphase = cumsum(vfreqs);
        x = exp(%i * vphase);
        dbg.vfreqs = vfreqs;
        dbg.omax = omega_max;
        dbg.vphase = vphase;
        dbg.x1 = x;
    end;
    
    
//    if(mod.wf.is_fsk)
//      x = mod.wf.modul(b,mod.ovs);
//    else
//      x = mod.wf.modul(b);
//    end;
//    
//    // Filtre de mise en forme
//    if(mod.wf.linear)
//        x = upsample(x, mod.ovs);
//        [mod.psf,x] = psfilter_process(mod.psf,x);
//        x = x .* mod.ovs;
//    end;

    // Modulation RF
    if(mod.fi ~= 0)
        n = length(x);
        //t = linspace(0,(n-1)/mod.fs,n)';
        t = ((0:n-1)') / mod.fs;
        x = x .* exp(2*%pi*%i*mod.fi*t);
        if(mod.mode == 'r')
            x = real(x);
        end;
    end;
    
    if(argn(1) > 2)
        varargout(1) = dbg;
    end;
    
endfunction
