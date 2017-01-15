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



function lf = lf_init(varargin)
// Initialization of a first or second order loop filter for use in a carrier recovery PLL
// Calling Sequence
// lf = lf_init();           // Default is first order loop, with tc = 10 samples
// lf = lf_init(1, tc);      // First order loop filter
// lf = lf_init(2, BL, eta); // Second order loop filter
//
// Parameters
// tc: Time constant, in samples
// BL: Loop bandwidth, normalized to sample frequency
// eta: Damping factor
// lf: Returned loop filter object
//
// Description
// The returned object can be used as a component in a carrier recovery process
// (see <link linkend="carrier_rec_init">carrier_rec_init</link>), or directly with the <varname>process</varname> method.
// A first order loop can recover and track the carrier phase (and the carrier frequency is supposed to be low compared to the symbol rate).
// A second order loop can also recover and track the carrier frequency.
//
// <refsection><title>Example 1: First order loop filter</title></refsection>
// <programlisting>
//  wf = wf_init('bpsk');
//  lf = lf_init(1, tc = 10); // First order loop filter
//  // lf can be used now with carrier_rec_init
// </programlisting>
//
// <refsection><title>Example 2: Second order loop filter</title></refsection>
// <programlisting>
//  fs  = 1e6;  // 1 MHz sampling frequency
//  BL  = 10e3; // 10 KHz loop bandwidth (e.g. ~ 100 samples to converge)
//  eta = 1;    // Damping factor 
//  lf = lf_init(2,BL/fs,eta);
//  // lf can be used now with carrier_rec_init
// </programlisting>
//
// See also
//  ped_init
//  carrier_rec_init
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>
//
// Bibliography
//  DVBS2 : <emphasis>Carrier phase synchronization techniques for broadband satellite transmissions</emphasis>, ESA, 2003
// 

function [so,theta] = fopll_process(fo,ped)
// First order PLL for carrier phase / frequency recovery
// Calling Sequence
//  [so,theta] = fopll_process(fo,ped)
// Parameters
//  fo: First-order loop object (created with fopll_init(...))
//  ped: Phase Error Detector object (for instance, created with ped_psk(...))
//  theta: Current phase of the PLL
// 
// See also
//  fopll_init
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>
//     
    fo.theta    = fo.theta + fo.gamma * ped;
    theta       = fo.theta;
endfunction

function [so,theta] = sopll_process(so,ped)    
    so.theta    = so.theta + so.mu;
    so.mu       = so.mu + so.gamm * ((1 + so.rho) * ped - so.last_ped);
    so.last_ped = ped;
    theta       = so.theta;
endfunction

    if(argn(2) == 0)
        order = 1;
        tc    = 10;
    else
        order = varargin(1);
        if(order == 1)
            tc = 10;
            if(argn(2) >= 2)
                tc = varargin(2);
            end;
        else
            if(argn(2) < 3)
                error("lf_init(2,...): parameters missing (BL and eta).");
            end;
            BL  = varargin(2);
            eta = varargin(3);
        end;
    end;
    
    lf.order = order;
    if(order == 2)
        A        = 1; // PED gain at origin = 1 (ped supposed to be normalized)
        lf.BL    = BL;
        lf.eta   = eta;
        lf.A     = A; 
        lf.gamm  = (16 * eta * eta * BL)  / (A * (1 + 4 * eta * eta));
        lf.rho   = (4 * BL) / (1 + 4 * eta * eta);
        lf.theta = 0;
        lf.mu    = 0;
        lf.last_ped = 0;
        lf.process = sopll_process;
    elseif(order == 1)
        lf.A       = 1;
        lf.tc      = tc;
        lf.theta   = 0;
        lf.process = fopll_process;
        lf.gamma   = iir1_design('tc', tc);
    else
        error("Loop filter order must be either 1 or 2.");
    end;
endfunction;








