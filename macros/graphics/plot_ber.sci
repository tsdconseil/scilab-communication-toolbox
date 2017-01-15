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

function plot_ber(varargin)
// Plot Bit Error Rate (BER) in log domain
//
// Calling Sequence
// plot_ber(snr,ber[,format]); // Plots empirical BER
// plot_ber(wf[,format]);      // Plots theorical BER
//
// Parameters
// snr: Signal to noise ratio, in dB
// ber: Bit-error rate
// format: Format string, as for plot function
// wf: Waveform object or string identifying the waveform type (e.g. 'bpsk', 'qpsk', ...)
//
// Description
// This is just a call to standard plot function, followed by setting the log flag to 'nl' (logarithmic view of the BER).
//
// <refsection><title>Example</title></refsection>
// <programlisting>
// clf();
// plot_ber('bpsk','b-');
// plot_ber('fsk','rs');
// legend(['bpsk','fsk']);
// </programlisting>
// <mediaobject><imageobject><imagedata fileref="ex_plot_ber.png" format="PNG"/></imageobject><caption><para>BPSK bit error rate</para></caption></mediaobject> 
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

    rhs = argn(2);
    
    if(rhs < 1)
        error("plot_ber: argument(s) required.");
    end;

    snr = -2:12;
    argc = 1;
    if(type(varargin(1)) == 17) // mlist
        ber = varargin(1).ber(snr);
    elseif(type(varargin(1)) == 10) // string
        wf  = wf_init(varargin(1));
        ber = wf.ber(snr);
    else
        if(rhs < 2)
            error("plot_ber: invalid arguments.");
        end;
        snr = varargin(1);
        ber = varargin(2);
        argc = 2;
    end;

    if(rhs > argc)
        plot(snr,ber,varargin(argc+1));
    else
        plot(snr,ber);
    end;
    a = gca();
    a.log_flags = 'nl';
endfunction


