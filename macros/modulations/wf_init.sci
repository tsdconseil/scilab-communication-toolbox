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

function wf = wf_init(name, varargin)
// Initialization of a waveform object
// 
// Calling Sequence
//  wf = wf_init('bpsk')
//  wf = wf_init('qpsk')
//  wf = wf_init('8psk')
//  wf = wf_init('psk'[,M=2])
//  wf = wf_init('oqpsk')
//  wf = wf_init('fsk'[,M=2,index=0.5,filt='n',BT=0.8])
//  wf = wf_init('gfsk'[,index=0.5])
//  wf = wf_init('gmsk')
//  wf = wf_init('msk')
//  wf = wf_init('ask'[,M=2,K1=-1,K2=2/(M-1)])
//  wf = wf_init('ook')
//  wf = wf_init('qam',M)
//
// Parameters
//  wf: Output waveform object
//  M: Number of possible symbols (number of bits per symbol is <latex>$k=log_2(M)$</latex>). Default value is 2 (1 bit / symbol).
//  index: Modulation index for FSK modulations (ratio between excursion and symbol frequency). Default value is 0.5 (e.g. MSK)
//
// Description 
//  A waveform object is the theorical description of a waveform. It can be used to configure a modulator or a demodulator, or to plot a constellation diagram.
//  By default, the pulse shaping filter for the waveform is NRZ. This can be changed afterwards using the <link linkend="wf_set_filter">wf_set_filter</link> function.
//  
//  Support the following modulation types:
//   phase modulations (BPSK, QPSK, M-PSK),
//   amplitude modulations (ASK / OOK),
//   quadrature phase / amplitude modulations (QAM),
//   frequency modulations (M-FSK, with or without gaussian filtering).
//
// <refsection><title>Example</title></refsection>
// <programlisting>
//  wf = wf_init('qam64');
//  clf(); plot_const(wf);
// </programlisting>
// <mediaobject><imageobject><imagedata fileref="ex_wf_init.png" format="PNG"/></imageobject><caption><para>QAM64 constellation</para></caption></mediaobject>
// 
// See also
//  mod_init
//  demod_init 
//  plot_const
//  wf_set_filter
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

    name = convstr(name, 'l'); // to lower case
    rhs = argn(2);
    
    if(rhs >= 2)
        if(type(varargin(1)) == 15) // list
            varargin = varargin(1);
        end;
    end;
    
    select name
    case 'bpsk' then
        wf = wf_init('psk',2);
    case 'qpsk' then
        wf = wf_init('psk',4);
    case '8psk' then
        wf = wf_init('psk',8);
    case 'psk' then
        M     = 2;
        if(rhs >= 2)
            M = varargin(1);
        end;
        wf = psk(M);
    case 'oqpsk' then
        // TODO:
    case 'sqpsk' then
        // TODO:
    case 'fsk' then
        M     = 2;
        index = 0.5;
        filt  = 'n';
        BT    = 0.8;
        if(rhs >= 2)
            M = varargin(1);
        end;
        if(rhs >= 3)
            index = varargin(2);
        end;
        if(rhs >= 4)
            filt = varargin(3);
        end;
        if(rhs >= 5)
            BT = varargin(4);
        end;
        wf = fsk(M,index,filt,BT);
    case 'gfsk' then
        index = 0.5;
        if(rhs >= 2)
            index = varargin(1);
        end;
        BT = 0.8;
        if(rhs >= 3)
            BT = varargin(2);
        end;
        wf = wf_init('fsk',2,index,'g',BT);
    case '4fsk' then
        index = 0.5;
        if(rhs >= 2)
            index = varargin(1);
        end;
        filt  = 'n';
        BT    = 0.8;
        if(rhs >= 3)
            filt = varargin(2);
        end;
        if(rhs >= 4)
            BT = varargin(3);
        end;
        wf = fsk(4,index,filt,BT);
    case '4gfsk' then
        index = 0.5;
        if(rhs >= 2)
            index = varargin(1);
        end;
        wf = wf_init('fsk',4,index,'g',0.8);
    case 'gmsk' then
        wf = wf_init('fsk',2,0.5,'g',0.8);
    case 'msk' then
        wf = wf_init('fsk',2,0.5,'n',0.0);
    case 'ask' then
        M  = 2;
        K1 = -1;
        if(rhs >= 2)
            M = varargin(1);
        end;
        // -1 + (M-1) * K2 = 1
        // K2 = 2 / (M-1)
        K2 = 2 / (M-1); 
        if(rhs >= 3)
            K1 = varargin(2);
        end;
        if(rhs >= 4)
            K2 = varargin(3);
        end;
        wf = ask(M,K1,K2);
    case 'ook' then
        wf = ask(2,0,1);
        wf.name = 'ook';
    case 'qam' then
        M = varargin(1);
        wf = qam(M);
    case 'qam256' then
        wf = wf_init('qam', 256);
    case 'qam64' then
        wf = wf_init('qam', 64);
    case 'qam16' then
        wf = wf_init('qam', 16);
    else
        error(sprintf("wf_init: unknown waveform type ''%s''.", name));
    end
    
    // Default pulse shaping filter
    //wf.psfilter = 'none';
    // Default over-sampling ratio
    //wf.ovs      = 1;
    //if(~wf.linear)
        // For frequency modulation
        // Pulse shaping is mandatory
        //wf.ovs = 8; // default, can be changed
        //wf.psfilter = 'ma';
    //end;
    
    // Default pulse shaping filter (NRZ)
    wf = wf_set_filter(wf, 'rect');
    
endfunction

function mod = ask(M,K1,K2)

    k = log2(M);
    deff('x = modul(b)', sprintf('x=symmap(b,%d,''b'')', k));
    deff('b = demodul(x)', sprintf('b=symdemap(x,%d,''b'')', k));
    deff('ber = lber(ebno)', sprintf('ber=berawgn(''ask'',ebno,%d)', M));
    deff('s = lookup(x)', sprintf('s = ask_symbol_lookup(x,%d,%d,%d)', k, K1, K2));
    
    mod.name = 'ask';
    if(M <> 2)
        mod.name = string(M) + 'ask';
    end;
    mod.ber = lber;
    mod.gene_symboles = modul;
    mod.demodul = demodul;
    mod.lookup = lookup;
    mod.k = k;
    mod.M = M;
    mod.linear = %t;
    mod.is_psk = %f;
    mod.is_qam = %f;
    mod.is_fsk = %f;
    mod.is_ask = %t;
endfunction

function mod = fsk(varargin) // M,index,filt,BT
    

    [lhs,rhs] = argn(0);
    
    M = 2;
    if(rhs >= 1)
        M = varargin(1);
    end;
    k = log2(M);
    
    index = 0.5;
    if(rhs >= 2)
        index = varargin(2);
    end;
    
    filt = 'n';
    if(rhs >= 3)

        filt = varargin(3);
    end;
    
    BT = 0.8;
    if(rhs >= 4)
        BT = varargin(4);
    end;
    
    //deff('x = modul(b,osf)', sprintf('x=fsk_mod(b,%d,%f,''%s'',%f,osf)', M, index, filt, BT));
    deff('x = gene_symboles(b)', sprintf('x = symmap(b,%d,''b'')', k));
    deff('b = demodul(x)', sprintf('b = symdemap(x,%d,''b'')', k));
    deff('y = ber(x)', sprintf('y = berawgn(''fsk'',x,%d)', M));
    
    
    letter = 'f';
    if(index == 0.5)
        letter = 'm';
    end;
    
    filts = '';
    if(filt == 'g')
        filts = 'g';
    end;
    
    if(M == 2)
      mod.name = filts + letter + 'sk';
    else
      mod.name = string(M) + filts + letter + 'sk';
    end;
    
    mod.index = index;
    mod.gene_symboles = gene_symboles;
    mod.demodul = demodul;
    mod.ber = ber;
    mod.M = M;
    mod.k = log2(M);
    mod.linear = %f;
    mod.is_psk = %f;
    mod.is_qam = %f;
    mod.is_fsk = %t;
    mod.is_ask = %f;
endfunction





function mod = psk(varargin)
    
    [lhs,rhs] = argn(0);
    
    M = 2;
    if(rhs >= 1)
        M = varargin(1);
    end;
    
    k = log2(M);
    
    deff('x = modul(b)', sprintf('x=symmap(b,%d,''p'');', k));
    deff('b = demodul(x)', sprintf('b=symdemap(x,%d,''p'')', k));
    deff('b = ber(ebno)', sprintf('b = berawgn(''psk'',ebno,%d)', M));
    deff('s = lookup(x)', sprintf('s = psk_symbol_lookup(x,%d)', k));
    
    if(M == 2)
        mod.name = 'bpsk';
    elseif(M == 4)
        mod.name = 'qpsk';
    else
        mod.name = string(M) + 'psk';
    end;
    mod.gene_symboles = modul;
    mod.demodul = demodul;
    mod.lookup = lookup;
    mod.ber = ber;
    mod.k = k;
    mod.M = M;
    mod.linear = %t;
    mod.is_psk = %t;
    mod.is_qam = %f;
    mod.is_fsk = %f;
    mod.is_ask = %f;
endfunction

function mod = qam(M)
    
    k = log2(M);
    deff('x = modul(b)', sprintf('x = symmap(b,%d,''q'')', k));
    deff('b = demodul(x)', sprintf('b = symdemap(x,%d,''q'')', k));
    deff('b = ber(ebno)', sprintf('b = berawgn(''qam'',ebno,%d)', M));
    
    mod.ber = ber;
    mod.name = 'qam' + string(M);
    mod.gene_symboles = modul;
    mod.demodul = demodul;
    mod.k = k;
    mod.M = M;
    mod.linear = %t;
    mod.is_psk = %f;
    mod.is_qam = %t;
    mod.is_fsk = %f;
    mod.is_ask = %f;
endfunction


// A VERIFIER !!!
function s = ask_symbol_lookup(x,k,K1,K2)
    x = round((x - K1) ./ K2);
    s = K2 * (x + K1);
endfunction


function s = psk_symbol_lookup(x,k)
    x = atan(imag(x),real(x));
    x = round(x .* (2^k) ./ (2 * %pi));
    s = exp(2*%pi*%i .* x ./ (2^k));
endfunction


