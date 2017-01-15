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

function mod = mod_init(wf,fs,fi,fsymb,varargin)
// Creation of a modulator object
//
// Calling Sequence
//  mod = mod_init(name,fs,fi,fsymb[,mode])
//  mod = mod_init(wf,fs,fi,fsymb[,mode])
//
// Parameters
// name: Waveform name ('bpsk', 'qpsk', 'qam16', ...: same parameter as <link linkend="wf_init">wf_init</link>)
// wf: Waveform object (created with <link linkend="wf_init">wf_init</link>)
// fs: Output sample frequency (in Hz)
// fi: Output intermediate (or RF) frequency (in Hz)
// fsymb: Symbol frequency (in Hz)
// mode: Real modulation ('r') or I/Q modulation ('c'). Default is real modulation.
//
// Description
//  In the first form, the default waveform configuration is used (NRZ pulse shaping, and default waveform parameters). In the second form, the user can configure more accurately the waveform.
// Examples
//  // QPSK modulator, NRZ pulse shaping,
//  // sampling frequency = 1 MHz, IF = 200 KHz, FSYMB = 20 KHz
//  mod = mod_init('qpsk', 1e6, 200e3, 20e3);
//  
//  // BPSK modulator, SRRC pulse shaping (r = 0.2), same frequencies
//  wf  = wf_init('bpsk');
//  wf  = wf_set_filter(wf, 'srrc', 0.2);
//  mod = mod_init(wf, 1e6, 200e3, 20e3);
// 
// See also
//  mod_process
//  wf_init
//  wf_set_filter
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

    if(type(wf) == 10)
        wf = wf_init(wf);
    end;
    mod.mode = 'r';
    if(argn(2) == 5)
        mod.mode = part(varargin(1),1);
    end;
    if((mod.mode ~= 'r') & (mod.mode ~= 'c'))
        error("mod_init(): mode must be either ''r'' (real modulation) or ''c'' (complex modulation).");
    end;
    mod.wf = wf;
    mod.fs = fs;
    mod.fi = fi;
    mod.fsymb = fsymb;
    mod.ovs = fs / fsymb;
    if(modulo(fs,fsymb) ~= 0)
        error("mod_init: sample frequency must be a multiple of symbol frequency.");
    end;
    
    
    mod.psf = psfilter_init(wf.ftype, mod.fs/mod.fsymb, wf.fparam);
    
endfunction

