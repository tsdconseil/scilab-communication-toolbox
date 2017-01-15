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


// Sampling rate = 48 kHz, real signal @ 12 kHz
fs = 48e3; f = 12e3;
t = (0:1/fs:1)';
x = sin(2*%pi*f*t);
clf();
plot_psd(x,fs);
cdir = get_absolute_file_path("ex_plot_psd.sce");
xs2png(gcf(), cdir + '../../help/en_US/graphics/ex_plot_psd1.png');


// Sampling rate = 48 kHz, complex signal @ 12 kHz
fs = 48e3; f = 12e3;
t = (0:1/fs:1)';
x = exp(2*%pi*%i*f*t);
clf();
plot_psd(x,fs);
cdir = get_absolute_file_path("ex_plot_psd.sce");
xs2png(gcf(), cdir + '../../help/en_US/graphics/ex_plot_psd2.png');


clf();
x = sct_test_signal1();
plot_psd(x,1e6,100e3,300e3);
xs2png(gcf(), cdir + '../../help/en_US/graphics/ex_plot_psd3.png');
