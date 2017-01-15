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

function y = fading_chn_process(chn, x)
// Simulation of a fading channel (Rayleigh or Rice model)
//
// Calling Sequence
// y = fading_chn_process(chn,x);
//
// Parameters
// chn: Fading channel object (see <link linkend="fading_chn_init">fading_chn_init</link>)
// x: Input baseband signal
// y: Output baseband signal, after fading.
//
// Description
// Proceed to Rayleigh or Rice model simulation on a signal, 
// represented in baseband form.
//
// <refsection><title>Example</title></refsection>
// <programlisting>
//   fd = 10;  // Maximum doppler shift = 10 Hz
//   fs = 1e4; // Sampling frequency = 10 kHz
//   chn = fading_chn_init('rice', fd, fs, 0.0);
//   x = ones(fs,1); // 1 second
//   x = fading_chn_process(chn,x); 
// </programlisting>
// <mediaobject><imageobject><imagedata fileref="ex-chn-simu1.png" format="PNG"/></imageobject><caption><para>Example of channel simulation (channel magnitude)</para></caption></mediaobject>
//
// See also
//  fading_chn_init
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>


    n = length(x);
    // (1) Generate m samples 
    fs2 = 4 * chn.fd;
    m = ceil(n * fs2 / chn.fs); 
    
    noise = (rand(m+chn.dpl.ntaps,1) + %i * rand(m+chn.dpl.ntaps,1)) / sqrt(2);
    if(chn.type == 'rayleigh')
        
    elseif(chn.type == 'rice')
        // x = a + n
        // K = a²/sigma²
        // => a = sigma sqrt(K)
        noise = sqrt(chn.K) + noise;
        // normalisation : 
        //noise = noise ./ sqrt(chn.K ^ 2 + 1);
        noise = noise ./ sqrt(mean(noise .* noise));
    else
      error('chnsimu: invalid channel.'); 
    end;
    
    x1 = convol(chn.dpl.h,noise);
    x1 = x1(3*chn.dpl.ntaps/2:3*chn.dpl.ntaps/2+m);
    // (4) upsample to fs
    x2 = intdec(real(x1),fs/fs2);
    x2 = x2 + %i * intdec(imag(x1),fs/fs2);
    x = x(:);
    x2 = x2(:);
    y = x .* x2(1:n);
endfunction
