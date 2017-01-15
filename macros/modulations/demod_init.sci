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

function demod = demod_init(wf,fs,fi,fsymb)
// Initialization of a demodulator object.
// 
// Calling Sequence
//  demod = demod_init(name,fs,fi,fsymb)
//  demod = demod_init(wf,fs,fi,fsymb)
// 
// Parameters
// name: classical waveform name ('bpsk', 'qpsk', 'qam16', ...)
// wf: Waveform object (created with <link linkend="wf_init">wf_init</link>)
// fs: Input sample frequency
// fi: Intermediate (or RF) frequency
// fsymb: Symbol frequency
// 
// Examples
//  // QPSK demodulator (NRZ matched filter),
//  // sampling frequency = 1 MHz, IF = 200 KHz, FSYMB = 20 KHz
//  demod = demod_init('qpsk', 1e6, 200e3, 20e3);
// 
// See also
//  demod_process
//  wf_init
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>
    
    if(type(wf) == 10)
        wf = wf_init(wf);
    end;

    demod.wf = wf;
    demod.fs = fs;
    demod.fi = fi;
    demod.fsymb = fsymb;
    demod.osf = fs / fsymb;
    if(modulo(fs,fsymb) ~= 0)
        error("demod_init: sample frequency must be a multiple of symbol frequency.");
    end;
    
    l = wf.fparam;
    l(0) = 3 * demod.fs/demod.fsymb; // Ntaps for pulse shaping filter
    
    demod.psf = psfilter_init(wf.ftype, demod.fs/demod.fsymb, l);
    demod.nu = fi / fs;
    demod.dn   = downconvert_init(demod.nu,'c');
    // cr = clock_rec_init(osf[,ted,itrp,tc])
    demod.cr   = clock_rec_init(demod.osf);
    
    if(wf.is_psk)
      if(wf.M >= 4) // QPSK, 8PSK, ...
        demod.cr.ted = ted_qpsk();
      end;
      ped = ped_init('psk',wf.M,2*demod.osf);
      demod.crr  = carrier_rec_init(ped, lf_init(2,0.05,1));
    elseif(wf.is_ask)
       ped = ped_init('ask',1,5*demod.osf); // 
       demod.crr  = carrier_rec_init(ped, lf_init(2,0.05,1));
    end;
    
endfunction;

