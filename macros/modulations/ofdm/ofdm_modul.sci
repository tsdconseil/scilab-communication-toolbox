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

function ofdm = ofdm_init(M,osf,gi_len)
// Initialization of the parameters of a OFDM modulator / demodulator
// Parameters
// gi_len: length of Guard Interval (GI), in samples

    ofdm.M   = M;
    ofdm.osf = osf;
    ofdm.gilen = gi_len

endfunction


function y = ofdm_modul(ofdm,x)
    // Note : en sortie, le signal est échantilloné à fsymb
    // Pour avoir un filtre NRZ comme en OFDM canonique,
    // Il faut sur-échantillonner et filtrer avant d'envoyer au DAC
    // (à moins que le DAC soit un 0th order hold, auquel cas
    //  il n'y a rien à faire).
    
    // Solution 1 : filtrage moyenne mobile de période T (période courte)
    // PB : on se retrouve comme en simple porteuse, spectre non plat !
    // Solution 2 : 
    
    M = ofdm.M;
    osf = ofdm.osf;
    gilen = ofdm.gilen;
    
    // Partition polyphase
    X = polyphase_form(x,M);
    // Nombre d'échantillons par canal
    nspl = size(X,2);
    
    
    // Longueur d'un symbole OFDM, en échantillons
    slen = (M+gilen)*osf;
    
    // Vecteur de sortie
    y = zeros(nspl*slen,1);
    
    // Création des raccordement (pulse shaping)
    
    
    for i = 1:nspl
        
        v = X(:,i);
        
        // Sur-échantillonnage si demandé
        // (équivalent à ajouter des zéros avant de faire la FFT)
        if(osf > 1)
            v = [v ; zeros((osf-1)*M,1)];
        end;
        
        tf = fft(v);
        
        // Ajout intervalle de garde : copie de la fin de la TF
        if(gilen > 0)
          tf = [tf($-gilen*osf+1:$) ; tf];
        end;
        
        // Pulse shaping
        

        y((i-1)*slen+1:i*slen) = tf;
    end
    
    //y = rectpulse(y,osf);
endfunction

// Basé sur channelize
function y = ofdm_modul2(x,N,osf)
    X = polyphase_form(x,N);
    y = channelize(X',ones(N,1));
endfunction

function P = ofdm_carriers(N,osf)
    // exp(2*%pi*%i*(0:N-1)' * (0:N-1)/N);
    P = exp(2*%pi*%i*(0:N-1)' * (0:N*osf-1)/(N*osf));
endfunction

function y = ofdm_analog(x,N,osf)
// Simulation analogique de la modulation OFDM (sans utiliser de FFT)
// 

    // Partition polyphase
    X = polyphase_form(x,N);
    ncols = size(X,2);
    
    VEXP = ofdm_carriers(N,osf);
    
    y = zeros(ncols*N*osf,1);
    for i = 1:ncols
        somme = zeros(1,N*osf);
        for j = 1:N
           somme = somme + X(j,i) * VEXP(j,:);
        end;
        y((i-1)*N*osf+1:i*N*osf) = somme';
    end;
endfunction

// Question : est-ce que avec un sur-échantillonnage de la méthode FFT
// on a la même chose qu'avec suréchan des sous-porteuses ?


function test1()
NS = 1024;
N  = 8;
osf = 8;
x = 2*prbs(NS)-1;
gilen = 2;
ofdm = ofdm_init(N,osf,gilen);
y = ofdm_modul(ofdm,x);
y2 = ofdm_analog(x,N,osf);

scf(0); clf();
subplot(311);
plot(y); 
subplot(312);
plot(y2);
subplot(313);
//plot(y-y2);  
scf(1); clf();
subplot(211);
plot_psd(y,osf);
xtitle("Spectre du signal OFDM discret")
subplot(212);
plot_psd(y2,osf);
xtitle("Spectre du signal OFDM continu")


scf(2); clf();
P = ofdm_carriers(N,osf);
legs = [];
plot((0:N*osf-1)'/osf,real(P'));
for i = 1:N
    legs = [legs 'Carrier # '+string(i-1)];
end
legend(legs);
a = gca();
a.data_bounds = [-0.1,-1.1;N+0.1,1.1];
xtitle("Carriers (time domain)");
scf(3); clf();
xtitle("Carriers (frequency domain)");
for i = 1:N
  //plot2d(frmag(P(i,:)',512),style=i);
  plot2d((0:N*osf-1)'/osf,20*log10(1e-8+abs(fftshift(fft(P(i,:)')))),style=i);
end
legend(legs);
endfunction


function plot_carriers()
    
    //xdel(winsid());
    scf(0);
    clf();
    T = 1;
    fs = 100;
    N = 4;
    t = linspace(0,T,T*fs);
    t = t';
    Y = [];
    XM = [];
    
    // f0 = 0Hz
    // f1 = 1/T Hz
    // ...
    // f_{N-1} = (N-1)/T Hz
    // T = période symbole OFDM.
    // ---> Valeur min = en fonction Bc (T > 1/Bc)
    // N = nombre de sous-porteuses
    // E.g. pour un symbole de durée T,
    // on a une séparation fréquentielle
    // de df = 1/T Hz.
    // T augmente => df diminue
    
    for k = 1:N
        y = exp(2*%pi*%i*(k-1)*t/T);
        
        y = [zeros(T*fs,1); y; zeros(T*fs,1)];
        
        Y = [Y y];
        //y = [y(1:8:$) ; zeros(fs*16,1)];
        y = [y ; zeros(T*fs*13,1)];
        xm = fftshift(abs(fft(y)));
        npts = length(xm);
        // On va analyser entre 0 Hz et N-1/T Hz
        // Or un bin FFT = 1/16 Hz //////(1/16) * 1 / (T*fs) Hz
        
        // N/T Hz          = ? bins >>> N/T
        // 1/16 Hz            = 1 bin
        
        
        //xm = 20*log10(xm(npts/2-16*N/T:npts/2+16*N/T+12*N/T));
        xm = xm(npts/2-16*N/T:npts/2+16*N/T+12*N/T);
        npts = length(xm);
        fr = linspace(0,N/T,npts);
        //[xm,fr] = frmag(y',512);
        //xm = xm(:);
        XM = [XM xm];
    end
    t = linspace(-T,2*T,3*T*fs);
    plot(t,Y);
    a = gca();
    a.data_bounds = [-0.2, -1.1; 1.2, 1.1];
    legend(['k=0','k=1','k=2','k=3']);
    xtitle('Fonctions de base pour chaque sous-porteuse (partie réelle)');
    a.title.font_size = 4;
    scf(1); clf();
    fr = fr(:);
    plot(fr, XM);
    legend(['k=0','k=1','k=2','k=3']);
    xtitle('Spectre des fonctions de base');
    a = gca();
    a.title.font_size = 4;
    
    
endfunction

plot_carriers();

xs2pdf(0,'c:/dev/formations/sdr/presentation/ofdm/carriers-t.pdf');
xs2pdf(1,'c:/dev/formations/sdr/presentation/ofdm/carriers-f.pdf');

//test1();



