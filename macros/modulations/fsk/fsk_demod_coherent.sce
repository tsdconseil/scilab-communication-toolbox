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

function fcd = fcd_init(wf,fs,fsymb,nsy)
    fcd.M         = 2;
    fcd.NSMAX     = 8;
    fcd.ns        = 1;
    fcd.surv      = list();
    fcd.wf        = wf;
    fcd.fs        = fs;
    fcd.fsymb     = fsymb;
    fcd.seuil_sim = 1e-3;
    fcd.ovs       = fs/fsymb;
    fcd.wnd       = [];
    fcd.ns        = nsy;
    
    if(floor(fcd.ovs) ~= fcd.ovs)
        error("fcd_init(): oversampling ratio should be an integer.");
    end;
    
    ti.score = 0;
    ti.mod   = mod_init(wf,fs,0,fsymb);
    ti.bits  = [];
    fcd.surv(1) = ti;
endfunction

function sim = calc_sim(mod1, mod2)
    
endfunction

function [fdcp,y] = fcd_process(fdcp, x)
// Basé sur un Viterbi simplifié (K survivants)
// Parameters
// fdcp: Demodulator context (input / output), should be initialized with fsk_demod_coherent_init
// x: received signal
// y: output symbols

    x = x(:);
    y = [];
    
    // Tamponage des données pour avoir des périodes symboles
    while(length(x) > 0)
        nread = fdcp.ovs-length(fdcp.wnd);
        fdcp.wnd = [fdcp.wnd ; x(1:read)];
        x(1:nread) = [];
        if(length(fdcp.wnd) == fdcp.ovs)
            [fdcp,y1] = fcd_process_1symbole(fdcp,fdcp.wnd);
            y = [y ; y1];
            fdcp.wnd = [];
        end;
    end;

endfunction;
    
function [fcd,y] = fcd_process_1symbole(fcd,x)
    cand_score = zeros(fcd.M*fcd.ns, 1);
    cand_phase = list();
    bits = cand_phase;
    
    // Chaque survivant = la données de fcd.nsi symboles consécutifs
    // Pb : comparaison de la trajectoire de phase seulement sur le symbole
    // central
    
    for i = 1:fcd.ns
        
        // Calcul de la corrélation entre x[0..T-1] et l'évolution théorique du survivant
        
        // Les M symboles possibles
        for(s = 0:fcd.M-1)
            
            // Trajectoire théorique
            //traj = cons_traj(fdcp, fdcp.surv(i).phase, s);
            [mod2,traj] = mod_process(fcd.surv(i).mod,s);
            
            erreur = (traj - x) .^ 2;
            index = 1 + s + (i-1) * fdcp.M;
            cand_score(index) = fcd.surv(i).score - erreur;
            cand_phase(index) = mod2;
            bits(index) = [fcd.bits(i) s];
        end;
    end;
        
    // Sélection des NSMAX trajectoires les plus probables
    surv2 = list();
    if(fcd.M*fdcp.ns < fcd.NSMAX)
        // Pas besoin de trier
        for i = 1:fcd.M*fcd.ns
          el.score = cand_score(i);
          el.mod = cand_phase(i);
          el.bits = bits(i);
          surv2(i) = el;
        end;
        fcd.ns = fcd.M*fcd.ns;
    else
        [m, k] = gsort(cand_score);
        for i = 1:fcd.NSMAX
           el.score = m(i);
           el.mod = cand_phase(k(i));
           el.bits = bits(i);
           surv2(i) = el;
        end;
        fcd.ns = fcd.NSMAX;
    end;
    
    
    /// Post-traitements :
    ///  - Fusion des premiers bits identiques entre tous les survivants
    ///  - Gestion des cycles (idem sél. max. Viterbi)
    ///   (2 trajectoires qui arrivent à un point de phase identique : 
    ///    rien ne pourra les différencier dans le future)
    ///    => On doit comparer 2 à 2 la phase de tous les survivants
    ///    => coût en K² !!!!
    /// Aussi, si indice de modulation non rationel, il peut arriver
    /// que 2 trajectoires convergent vers des points de phase proches
    /// mais pas identiques. => idéalement il faudrait pouvoir les fusionner aussi.
    
    asupr = [];
    
    nsurv = length(surv2);
    
    for(i = 1:nsurv)
        for(j = i+1:nsurv)
            similarite = calc_sim(surv2(i).mod, surv2(j).mod);
            if(similarite <= fdcp.seuil_sim)
                // Fusion i et j
                asupr = [asupr j];
            end;
        end;
    end;
    
    agarder = setdiff(1:nsurv, asupr);
    fcd.surv = list();
    for i = 1:length(agarder)
        fcd.surv(i) = surv2(agarder(i));
    end;
    
endfunction















