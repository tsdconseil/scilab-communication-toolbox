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

function [x,fs,fi,fsymb,varargout] = sct_test_signal(varargin)
// Generation of test signal.
// 
// Calling Sequence
// [x,fs,fi,fsymb,b] = sct_test_signal();
// [x,fs,fi,fsymb,b] = sct_test_signal(num,opt)
//
// Parameters
// num: Test signal number (1 is BPSK, 2 is QPSK)
// opt: 'r' for real signal, 'c' for complex (baseband or low-if) signal
// x: Output signal (1d vector, complex or real)
// fs: Sampling frequency
// fi: Intermediate frequency
// fsymb: Symbol frequency 
// b: Binary sequence before modulation
//
// Description
// This function can be used so a to generate a test signal.
// The following signals are provided:
// <itemizedlist>
//   <listitem>Test signal n°=1: a 2 ms (2000 samples) BPSK signal, sampled at 1 MHz, with IF at 200 KHz and symbol frequency of 10 kbps.</listitem>
//   <listitem>Test signal n°=2: The same, but in QPSK.</listitem>
// </itemizedlist>
// 
// <refsection><title>Example</title></refsection>
// <programlisting>
// x = sct_test_signal();
// clf(); plot_psd(x,1e6);
// </programlisting>
// <mediaobject><imageobject><imagedata fileref="ex_tsig1.png" format="PNG"/></imageobject><caption><para>Test signal 1 (BPSK, with FI = 2 MHz) : power spectrum</para></caption></mediaobject>
// 
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

    num = 1;
    opt = 'r';
    if(argn(2) >= 1)
        num = varargin(1);
    end;
    if(argn(2) >= 2)
        opt = varargin(2);
    end;


    fs = 1e6;     // Sampling frequency: 1 MHz
    fi = 200e3;   // Intermediate frequency: 200 KHz
    fsymb = 10e3; // 10Ksymbols/second

    // Simulate a BPSK signal
    if(num == 1)
      wf = wf_init('bpsk');
    else
      wf = wf_init('qpsk');
    end;
    //wf = wf_set_filter(wf, 'srrc', 64, 0.5);
    wf = wf_set_filter(wf, 'gaussian', 64, 0.8);
    mod = mod_init(wf,fs,fi,fsymb,opt);
    b = prbs(100);
    [mod,x] = mod_process(mod,b);
    x = awgn(x,0.02);
    //if(opt == 'r')
    //    x = real(x);
    //end;
    if(argn(1) >= 5)
        varargout = list();
        varargout(1) = b;
    end;
endfunction

