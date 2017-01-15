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

nsymb = 80; // Generate 120 symbols
osf = 9;     // Input oversampling factor = 9 samples / symbol
cr = clock_rec_init(osf);
// Creation of a simple signal: NRZ filtered with its matched filter
// (moving average)
x = ma(nrz(prbs(nsymb),osf),osf);
// Apply a fractionnal delay
x = frac_delay(x, osf/2);
// Proceed to clock recovery
[cr,y,e] = clock_rec_process(cr,x);


///////// PLOTTING THE RESULTS
scf(0); clf(); 
subplot(311);
// Initial sampling points
xd = x(1:osf:$); 
t1 = linspace(0,nsymb,length(xd))'; 
//plot(t1,xd,'ob-');
plot_binary(xd);
//xtitle("Comparison before and after clock recovery", "Time", "Sampled signal");
xtitle("Avant recouvrement d''horloge");
a = gca(); a.title.font_size = 4;

subplot(312);
// Resampled output
t2 = linspace(0,nsymb,length(y))'; 
//plot(t2,y,'-bo');
plot_binary(y);
xtitle("Après recouvrement d''horloge");
a = gca(); a.title.font_size = 4;
//legend(['Initial sampling points';'After clock recovery'])
subplot(313);
plot(e.e*100,'r');
xtitle("Time error (in % of symbol period)", "", "Time error (%)");
a = gca(); a.title.font_size = 4;
cdir = get_absolute_file_path("ex_clock_rec_process.sce");
xs2png(gcf(), cdir + '../../help/en_US/clock-rec/ex_clock_rec_process.png');

//xs2pdf(gcf(), 'c:/dev/formations/sdr/presentation/interp/ex1.pdf');



