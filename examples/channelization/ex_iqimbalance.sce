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

function [g,phi] = iqi_est_moseley(x)
    
    x = x(:);
    
    I = real(x);
    Q = imag(x);
    n = length(x);

    t1 = -(sign(I') * Q) / n;    
    t2 = (sign(I') * I) / n;
    t3 = (sign(Q') * Q) / n;
    
    g = t3 / t2;
    phi = asin(t1 / t3);
endfunction

function ex_iqimbalance()
    
clf();
fs = 1e3;        // Sampling frequency
fi = 200.5245;   // Intermediate frequency
fsymb = fs / 20; // -> 50 Hz

mod = mod_init('qam16',fs,fi,fsymb);
[mod,x] = mod_process(mod,prbs(5000));
x = real(x);

n = length(x);
t = linspace(0,(n-1)/fs,n)';
g = 1.5;
phi = -10*%pi/180;

subplot(131);
plot(x(1:100));
xtitle("Signal d''origine modulé (qam16)");
a = gca();
a.title.font_size = 2;

subplot(132);
dn = downconvert_init(fi/fs);
[dn,x] = downconvert_process(dn,x);
x = iqi_simu(x,phi,g);


plot_const(x);
xtitle("Signal zéro IF, phi = " + string(round(phi*180/%pi)) + "°, g = " + string(g));
a = gca();
a.title.font_size = 2;

[g2,phi2] = iqi_est_moseley(x);
printf("MOSELEY :\n");
printf("g   = %.4f   --> g2   = %.4f.\n", g, g2);
printf("phi = %.4f   --> phi2 = %.4f.\n", phi, phi2);
printf("STD :\n");
[g2,phi2] = iqi_blind_est(x);
printf("g   = %.4f   --> g2   = %.4f.\n", g, g2);
printf("phi = %.4f   --> phi2 = %.4f.\n", phi, phi2);

subplot(133);
x = iqi_cor(x,g2,phi2);
plot_const(x);
xtitle("Après compensation");
a = gca();
a.title.font_size = 2;

cdir = get_absolute_file_path("ex_iqimbalance.sce");
xs2png(gcf(), cdir + '../../help/fr_FR/channelization/ex_iqimbalance.png');

endfunction

function ex_iqimbalance2()
    
clf();
fs = 1e3;        // Sampling frequency
fi = 0;//200.5245;   // Intermediate frequency
fsymb = fs / 20; // -> 50 Hz

mod = mod_init('qam16',fs,fi,fsymb);
[mod,x] = mod_process(mod,prbs(5000));

x = awgn(x,0.03,'c');

//x = real(x);

n = length(x);
t = linspace(0,(n-1)/fs,n)';
g = 1.5;
phi = -10*%pi/180;

subplot(131);
plot_const(x);
//plot(x(1:100));
xtitle("Signal d''origine modulé (qam16)");

subplot(132);
//dn = downconvert_init(fi/fs);
//[dn,x] = downconvert_process(dn,x);
x = iqi_simu(x,phi,g);


plot_const(x);
xtitle("Signal zéro IF, phi = " + string(round(phi*180/%pi)) + "°, g = " + string(g));

[g2,phi2] = iqi_est_moseley(x);
printf("MOSELEY :\n");
printf("g   = %.4f   --> g2   = %.4f.\n", g, g2);
printf("phi = %.4f   --> phi2 = %.4f.\n", phi, phi2);
printf("STD :\n");
[g2,phi2] = iqi_blind_est(x);
printf("g   = %.4f   --> g2   = %.4f.\n", g, g2);
printf("phi = %.4f   --> phi2 = %.4f.\n", phi, phi2);

subplot(133);
x = iqi_cor(x,g2,phi2);
plot_const(x);
xtitle("Après compensation");

cdir = get_absolute_file_path("ex_iqimbalance.sce");
xs2png(gcf(), cdir + '../../help/fr_FR/channelization/ex_iqimbalance.png');

endfunction

ex_iqimbalance2();


