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

function chn = fading_chn_init(name, varargin)
// Initialization of a fading channel object
//
// Calling Sequence
//  chn = fading_chn_init('rayleigh',fd,fs);
//  chn = fading_chn_init('rice',fd,fs,K);
//
// Parameters
// fd: Maximum doppler frequency (in Hz)
// fs: Sampling frequency (in Hz)
// K: Rician factor
//
// Description
// Creation of a fading channel simulator object.
// One can use the Rayleigh (when no dominent path exists) or the Rice (with a dominent path) model.
//
// A complete example can be found in the <link linkend="fading_chn_process">fading_chn_process</link> function.
// 
// See also
//  fading_chn_process
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

    
    // Gan model, according to Clarke's model
    // D'après "A MATLAB-based Object-Oriented Approach to Multipath Fading 
    //          Channel Simulation"
    // Equation 10
    function S = doppler_psd(f,fd,fc)
        S = 1.5 ./ (2*%pi*fd*sqrt(1-((f-fc)/fd).^2));
    endfunction
    
    function [h] = fsfir(f, varargin)
    f = f(:); // Vecteur colonne
    M = length(f);
    ntaps = 2 * M;
    if(argn(2) > 1)
        ntaps = varargin(1);
    end;
    //ntaps = apifun_argindefault(varargin, 1, 2 * M);
    
    if(ntaps <> 2 * M) then
        // Adapt number of coefficients
        n2 = ceil(ntaps / 2);
        f = interpln([linspace(0,0.5,M);f'],linspace(0,0.5,n2))';
        M = n2;
    end;
    
    // f = rÃ©ponse souhaitÃ©e sur les frÃ©quences positives
    // longueur = M
    // Pour avoir un filtre rÃ©el (2M coefficients rÃ©els, symÃ©trique) :
    //  Hd(-k) = Hd(k)*, et Hd(0) rÃ©el
    // Soit, pour une reprÃ©sentation pour i entre 1 et 2M,
    // avec i = 1   <=> k = 0       0     Hz
    //      i = 2   <=> k = 1       Fs/2M Hz
    //      .......                 
    //      i = M   <=> k = M-1     (M-1)Fs/2M Hz
    //      i = M+1 <=> k = M            Fs/2 Hz
    //      i = M+2 <=> k = -(M-1)
    //      i = M+3 <=> k = -(M-2)
    //      .......
    //      i = 2M  <=> k = -1    
    // Soit :
    // Hd(i, 2 <= i <= M) = Hd*(2M-(i-2))
    // Et Hd(i = M+1) rÃ©el
    //    Hd(i = 0) rÃ©el

    Hd = zeros(2*M,1);
    Hd(1:M) = f;

    // MÃ©thode alternative, mÃªme rÃ©sultat que fftshift    
    //om = (0:M-1)' /(2*M); // Freq norm, 0..0.5
    //Hd(1:M) = Hd(1:M) .* exp(-om*2*%pi*%i*(2*M-1)/2);
    
    for i = 2:M
      Hd(2*M-(i-2)) = conj(Hd(i));
    end;
    Hd(1)   = real(Hd(1));
    Hd(M+1) = 0; // FrÃ©quence de Nyquist
    
    h = fftshift(fft(Hd,1));
    //h = fft(Hd,1);

    // Juste un essai pour voir l'effet    
    wnd = window('tr',2*M)';
    h = h .* wnd;
endfunction
    
    
    function dpl = get_doppler_filter(fd,fs)
        fs2 = 4 * fd;
        ntaps = 512;
        f = linspace(0,2*fd,ntaps/2)';
        S = doppler_psd(f,fd,0);
        h = fsfir(real(S), ntaps);
        h = h ./ sum(h);
        dpl.h = h;
        dpl.fd = fd;
        dpl.fs = fs;
        dpl.ntaps = ntaps;
    endfunction
    
    
    chn.name = name;
    
    namel = convstr(name,'l');
    if(namel  == 'rayleigh') // Make a rayleigh channel
        fd = varargin(1);
        fs = varargin(2);
        chn.fd = fd;
        chn.fs = fs;
        chn.dpl = get_doppler_filter(fd,fs);
        chn.type = namel;
    elseif((namel == 'rice') | (namel == 'rician'))
        fd = varargin(1);
        fs = varargin(2);
        K  = varargin(3);
        chn.fd = fd;
        chn.fs = fs;
        chn.dpl = get_doppler_filter(fd,fs);
        chn.type = 'rice';
        chn.K = K;
    else
        error("fading_chn_init: unsupported channel type.");
    end;
endfunction
