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

curdir = get_absolute_file_path("ex-eye-diagram.sce");
exec(curdir + "../../macros/loadall.sce");

docdir = curdir + "../../../../comm-tbx-doc";

function test_eyediagram()
osf = 128;
nsymb = 500;
x = nrz(prbs(nsymb),osf);
x1 = ma(x, osf);
x1 = awgn(x1, 0.1);
x1f = ma(x1, osf); 
h = srrc_fir(r=0.5,osf,4*osf);
x2 = convol(h, x);
x2 = awgn(x2, 0.5);
x2 = convol(h, x2); 
clf();
subplot(211);
eyediagram(x1, osf);
subplot(212);
eyediagram(x1f, osf);
xs2jpg(gcf(), docdir + "/ug/img/eye.jpg");
endfunction;


function test_plot_const()
mod = get_mod('psk',8);
b = prbs(1000000);
x = mod.modul(b);
x = awgn(x,0.2);
clf();
plot_const(x);
xtitle(mod.name,'I','Q');
xs2jpg(gcf(), docdir + "/ug/img/scatterplot.jpg");

clf();
mod = get_mod('qam',16);
plot_const(mod);
xs2pdf(gcf(), docdir + "/ug/img/constplot.pdf");
endfunction

function test_psd()
    fs = 48e3;
    f = 12e3;
    t = linspace(0,1,fs);
    //x = exp(2*%pi*%i*f*t);//sin(2*%pi*f*t);
    x = sin(2*%pi*f*t);
    clf();
    plot_psd(x,fs);
    xs2pdf(gcf(), docdir + "/ug/img/psd.pdf");
endfunction

test_eyediagram();
//test_plot_const();
//test_psd();

// From http://www.dsprelated.com/showcode/275.php
//function[y] = Constellation_QPSK()
//M =4;
//i = 1:M;
//y = cos((2*i-1)*%pi/4)-sin((2*i-1)*%pi/4)*%i;
//annot = dec2bin([0:M-1],log2(M));
//disp(y,'coordinates of message points')
//disp(annot,'dibits value')
//figure;
//a =gca();
//a.data_bounds = [-1,-1;1,1];
//a.x_location = "origin";
//a.y_location = "origin";
//plot2d(real(y(1)),imag(y(1)),-2)
//plot2d(real(y(2)),imag(y(2)),-4)
//plot2d(real(y(3)),imag(y(3)),-5)
//plot2d(real(y(4)),imag(y(4)),-9)
//xlabel('                                             In-Phase');
//ylabel('                                             Quadrature');
//title('Constellation for QPSK')
//legend(['message point 1 (dibit 10)';'message point 2 (dibit 00)';'message point 3 (dibit 01)';'message point 4 (dibit 11)'],5)
//endfunction

//Constellation_QPSK();
