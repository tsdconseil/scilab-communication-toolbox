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

function y = channelize(X,h)
// Channelization: frequency multiplexing of m input signals into a single signal (but with bandwidth multiplied by m)
//
// Calling Sequence
// y = channelize(X)
//
// Parameters
// X: input matrix, size [n x m], with n: n samples / channel, and m: number of channels. Each column of X is a different signal. The number of columns (m) is the number of channels.
// y: output vector, size [nm x 1]
//
// Description
// Merge m different signals into a single vector, by frequency multiplexing.
// The signals are shifted at the following normalized frequencies: 0, 1/m, 2/m, ..., (m-1)/m.
// Note: this could be done more effectively using a modulated filter bank (Harris method, reciprocal algorithm of the unchannelize function).
// <programlisting>
// fs = 1e3;
// mod = mod_init("bpsk", fs=1e3,fi=0,fsymb=50);
// [mod,x] = mod_process(mod,prbs(1000));
// nchn = 8;
// // In this example, just duplicate the same channel 8 times
// X = repmat(x,1,nchn);
// y = channelize(X); // output sample rate is 8 times higher
// clf(); plot_psd(y,8*fs,'b');
// </programlisting>
// <imageobject><imagedata fileref="ex_channelize.png" format="PNG"/></imageobject>
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>
    
    n = size(X,1); // Nb éch / canal
    m = size(X,2); // Nb canaux

//    y = zeros(n*m,1);
//    
//    for i = 1:m
//        nu = (i-1) / m; // normalized frequency
//        xu = intdec(real(X(:,i)), m) + %i * intdec(imag(X(:,i)), m);
//        xm = xu .* exp(2*%pi*%i*nu*(0:n*m-1)');
//        y = y + xm;
//    end
//    
    
    
    // (4) DFT
    Y = fft(X',1,1); // IDFT suivant les colonnes (dim n°1)
    
    // Y : chaque ligne = une fréquence donnée
    
    // (3) polyphase partition of the filter
    H = polyphase_filter(h,m);
    // H : m lignes, len(h)/m colonnes
    
    // (2) Sortie du filtre polyphase
    n2 = n;
    n3 = n2 + (length(h)-1)/m;
    XF = zeros(m,n3);
    for i = 1:m
        XF(i,:) = convol(H(i,:),Y(i,:));
    end;

    // (1) polyphase partition of the signal
    // On suppose qu'on a un bloc de nchn échantillons
    // A partir du signal d'entrée de n échantillons,
    // on forme nchn signaux de n / nchn échantillons    
    y = polyphase_form(XF,m,-1);
    // Chaque ligne de X peut être traitée séparément
    
endfunction

