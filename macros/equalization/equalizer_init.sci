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

function eq = equalizer_init(wf,varargin)
// Creation of an equalizer object (LMS, CMA, ...)
//
// Calling Sequence
// eq = equalizer_init(wf); // Default equalizer (DDE, K = 1)
// eq = equalizer_init(wf,K,errf,struct,gain,N1[,N2]]); 
//
// Parameters
// wf: Waveform specification (see <link linkend="wf_init">wf_init</link>)
// K: Input over-sampling ratio (number of samples per symbol)
// errf: Error function (either 'slicer' or 'cma')
// struct: Equalizer structure (either 'dde' or 'dfe')
// gain: Update gain (determine the convergence speed)
// N1: Number of taps of the direct FIR equalization filter
// N2: Number of taps of the feedback FIR equalization filter (only for DFE equalization)
// eq: Resulting equalizer object (can be used with <link linkend="equalizer_process">equalizer_process</link>)
// 
//
// Description
// Initialize an equalizer object, ever symbol sampled (K = 1), or
// fractionnaly sampled (K > 1). Supported equalization structures are the
// following:
// <itemizedlist>
//   <listitem><para><emphasis role="bold">Decision Directed Equalization (DDE)</emphasis> <varname>(strucuture = 'dde'):</varname> A direct FIR filter is tuned (every symbol period) to minimize the output error.</para></listitem>
//   <listitem><para><emphasis role="bold">Decision Feedback Equalization (DFE)</emphasis> <varname>(strucuture = 'dfe'):</varname> Both a direct FIR filter (working at <latex>$K\cdot f_{symb}$</latex>) and a feedback filter (working at symbol frequency) on the decision (slicer) outputs are used.</para></listitem>
// </itemizedlist>
// 
// Possible cost function are the following:
// <itemizedlist>
//   <listitem><para><emphasis role="bold">Slicer</emphasis> <varname>(errf = 'slicer'):</varname> <latex>$E=(d-y)^2$</latex>. Note: with this error function, the algorithm is better known as <emphasis role="bold">LMS (Least Mean Square).</emphasis></para></listitem>.
//   <listitem><para><emphasis role="bold">Constant modulus algorithm (CMA)</emphasis> <varname>(errf = 'cma'):</varname> <latex>$E=\left(R-|y|^2\right)^2$</latex></para></listitem>
// </itemizedlist>
// For a complete example, see the <link linkend="equalizer_process">equalizer_process</link> function.
//
// See also
//  equalizer_process
//  wf_init
//
// Authors
//  J. Arzi, full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>    
    
    eq.wf           = wf;
    eq.structure    = 'dde';
    eq.errf         = 'slicer';
    eq.K            = 1;
    eq.gain         = 0.01;
    eq.N1           = 11;
    eq.N2           = 11;
    
    if(argn(2) > 1)
        eq.K = varargin(1);
    end;
    if(argn(2) > 2)
        eq.errf = varargin(2);
    end;
    if(argn(2) > 3)
        eq.structure = varargin(3);
    end;
    if(argn(2) > 4)
        eq.gain = varargin(4);
    end;
    if(argn(2) > 5)
        eq.N1 = varargin(5);
    end;
    if(argn(2) > 6)
        eq.N2 = varargin(6);
    end;
    
    if((eq.errf ~= 'cma') & (eq.errf ~= 'slicer'))
        error("equalizer_init: supported error function = ''slicer'' or ''cma''.");
    end;
    
    if(eq.structure == 'dfe')
      eq.h_avant    = [zeros(eq.N1-1,1) ; 1];
      eq.h_arriere  = [zeros(eq.N2,1)];
      eq.wnd        = zeros(eq.N1,1);
      eq.wnd_deci   = zeros(eq.N2,1);
      eq.cnt        = 0;
    elseif(eq.structure == 'dde')
      eq.h     = [zeros(eq.N1-1,1) ; 1];
      eq.wnd   = zeros(eq.N1,1);
    else
        error("equalizer_init: supported structures = ''dde'' or ''dfe''.");
    end;
    
    //if((eq.errf == 'cma') & (eq.structure ~= 'dde'))
      //  error("equalizer_init: CMA (Constant Modulus Algorithm) works only with DDE (Decision Directed Eq.).");
    //end;
    
    if(eq.errf == 'cma')
        
        eq.g2 = 1; // For PSK, FSK
        
        if(wf.is_qam)
            error("TODO: scale factor for QAM and CMA.");
        end;
    end;
    
endfunction


