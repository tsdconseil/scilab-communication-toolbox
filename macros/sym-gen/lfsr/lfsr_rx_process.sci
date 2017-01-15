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

function lfsr = lfsr_rx_process(lfsr, x)
// LFSR receiver implementation
// Calling Sequence
// lfsr = lfsr_rx_process(lfsr, x)
// Parameters
// lfsr: LFSR object
// x: input binary sequence
// Description
// The receiver can be in one of the following states:
// <itemizedlist>
//  <listitem><para>Unsynchronized state: in this mode, the receiver try to synchronize with the incoming bit stream.</para></listitem>
//  <listitem><para>Synchronized: in this mode, the receiver count the number of errors (difference between expected bits as computed at the output of the LFSR register and incoming bits).</para></listitem>
// </itemizedlist>
// At the beginning, the receiver is unsynchronized, and switch to synchronized mode if the error rate goes below a fixed threshold. In synchronized state, the receiver can also go back to unsynchronized state if the detected error rate is too high.
// See also
//  lfsr_rx_init
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

    
    n = length(x);
    for i = 1:n
        
        //[y,lfsrp] = lfsr_process(lfsr, 1);
        
        // Copy-paste instead, because otherwise CPU time multiplied by 10 !
        reg = lfsr.reg;
        tmp = reg & lfsr.poly;
        somme = uint32(0);
        for k = 1:lfsr.deg
            somme = somme + 1 * ((tmp & uint32(2^(k-1))) > 0);
        end
        somme = modulo(somme,uint32(2));
        reg = (reg / 2);
        reg = reg + (2^lfsr.deg) * somme;
        y = somme;
        
        
        if(lfsr.state == 0) then
            //////////////////////
            // Unlocked state
            //////////////////////
            // Update the register with received data
            lfsr.reg = (lfsr.reg / 2);
            lfsr.reg = lfsr.reg + (2^lfsr.deg) * x(i);
            
            if(y == x(i)) then
                lfsr.nb_cons_bits_ok = lfsr.nb_cons_bits_ok + 1;
            else
                lfsr.nb_cons_bits_ok = 0;
            end;
            
            if(lfsr.nb_cons_bits_ok > 20) then
                printf("prbs lock @%d.\n", lfsr.bit_counter);
                // 20 consecutive bits are good: lock the receiver
                lfsr.state = 1;
                lfsr.nb_cons_bits_errors = 0;
                lfsr.has_locked = %t;
            end;
        else
            //////////////////////
            // Locked state
            //////////////////////
            // Update the register with internally predicted symbol
            lfsr.reg = reg;//lfsrp.reg;
            lfsr.nb_bits = lfsr.nb_bits + 1;
            
            if(y == x(i)) then
                lfsr.nb_cons_bits_errors = 0;
            else
                lfsr.nb_cons_bits_errors = lfsr.nb_cons_bits_errors + 1;
                lfsr.nb_errors = lfsr.nb_errors + 1;
            end;
            if(lfsr.nb_cons_bits_errors > 5) then
              printf("prbs unlock @%d after %d bits (%d errors).\n", lfsr.bit_counter, lfsr.nb_bits, lfsr.nb_errors);
              // 5 consecutive bits are bad: unlock the receiver
              lfsr.state = 0;
              lfsr.nb_cons_bits_ok = 0;
            end;
        end;
        lfsr.bit_counter = lfsr.bit_counter + 1;
    end
    
    
endfunction

