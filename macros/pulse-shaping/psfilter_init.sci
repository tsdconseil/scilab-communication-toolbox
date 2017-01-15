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

function psf = psfilter_init(tp, osf, varargin)
// Creation of a pulse shaping filter
//
// Calling Sequence
//  psf = psfilter_init('none', osf)
//  psf = psfilter_init('nrz', osf)
//  psf = psfilter_init('srrc', osf, ntaps, roll_off)
//  psf = psfilter_init('rc', osf, ntaps, roll_off)
//  psf = psfilter_init('gaussian', osf, ntaps, BT)
//
//  Parameters
//  osf: Over-Sampling Factor (number of samples by symbol)
//  ntaps: Number of taps of the FIR filter approximation
//  roll_off: Roll-off factor (for RC / SRRC filters)
//  BT: Bandwidth-time product (for gaussian filter)
//
// Examples
//  // Gaussian filter, 4 samples/symbol, 16 taps FIR, B.T. = 0.5
//  psf = psfilter_init('g', 4, 16, 0.5);
//
// See also
//  psfilter_process
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>
    
    
    
    ftype = convstr(tp, 'l'); // to lower case

    psf.hdl = [];
    psf.ftype = ftype;
    psf.osf   = osf; // Over-sampling factor
    
    vi = 1;
    psf.ntaps = 3 * osf;
    
    vin = varargin;
    
    if((length(vin) == 1) & (type(vin(1)) == 15))
        //printf("vin = list. old:\n");
        //disp(vin);
        vin = vin(1);
        //printf("new:\n");
        //disp(vin);
    end;
    
    if((ftype ~= 'pam') & (ftype ~= 'none') & (ftype ~= 'nrz') & (ftype ~= 'rect'))
       if(length(vin) < 2)
           disp(vin);
           error(sprintf("psfilter_init(''%s'',osf=%.1f): some parameter is missing.", tp, osf));
       end;
        
       psf.ntaps = vin(1);
       vi = vi + 1;
    end;
    
    select ftype
    case 'pam' then        
        psf = psfilter_init('none',osf);
    case 'none' then
        r1 = floor(psf.ntaps/2);
        r2 = psf.ntaps - r1 - 1;
        psf.h = [zeros(r1,1) ; 1 ; zeros(r2,1)];
        psf.ftype = 'none';
    case 'nrz' then
        r1 = floor(psf.ntaps/2 - osf/2);
        r2 = psf.ntaps - r1 - osf;
        psf.h = [zeros(r1,1); ones(osf,1); zeros(r2,1)] ./ osf;
    case 'rect' then
        psf = psfilter_init('nrz',osf); // synonyme
    case 'srrc' then
        psf.roll_off = vin(vi);
        psf.h = srrc_fir(psf.roll_off,osf,psf.ntaps);
    case 'rc' then
        psf.roll_off = vin(vi);
        psf.h = rc_fir(psf.roll_off,osf,psf.ntaps);
    case 'gaussian' then
        BT = vin(vi);
        psf = psfilter_init('g', osf, psf.ntaps, BT);
    case 'gaussien' then
        BT = vin(vi);
        psf = psfilter_init('g', osf, psf.ntaps, BT);
    case 'g' then
        psf.BT = vin(vi);
        psf.h = gaussian_fir(psf.BT,osf,psf.ntaps);
        psf.h = convol(psf.h, ones(1,osf)/osf);
    else
        error(sprintf("psfilter_init: unknown filter type ''%s''.", ftype));
    end
endfunction
