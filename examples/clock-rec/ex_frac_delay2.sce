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

cdir = get_absolute_file_path("ex_frac_delay2.sce");

fe  = 20; // Sampling frequency
t = (0:1/fe:1)';
x = sin(2*%pi*t*.7);
y1 = frac_delay(x, 0.5);        // Fractionnal delay: interpolation method
y2 = frac_delay(x, 0.5, 'dft'); // Fractionnal delay: DFT method
scf(0); clf(); 
plot(fe*t,x,'bs-'); plot(fe*t,y1,'ms-'); plot(fe*t,y2,'gs-');

xtitle("Fractionnal delay: DFT VS interpolation method", "Time (samples)");
legend(['input signal';'With delay of 0.5 sample (interpolation method)';'With delay of 0.5 sample (DFT method)']);

xs2png(gcf(), cdir + '../../help/en_US/clock-rec/ex_frac_delay_comp.png');

//
t = (0:1/20:1)';
x = sin(4*%pi*t);
y = frac_delay(x, 0.5); // Delay by 1/2 sample



[x,y] = pad(x,y);

scf(1); clf(); plot([x y]);
xs2png(gcf(), cdir + '../../help/en_US/clock-rec/ex_frac_delay.png');
//

// TEST FRAC DELAY
//fe  = 100;
//t = linspace(0,1,fe)';
//x = sin(2*%pi*t*10); // 10 périodes
//clf();
//x2 = intdec(x,100);
////plot(x2(100:200),'b-');
//plot(linspace(1,10,2001)',x2(1000:2000),'b-');
//y = frac_delay(x, 0.50);
//y2 = intdec(real(y),100);
//plot(y2(1000:2000),'g-');
//
//legend(['input signal';'With delay of 0.5 sample']);
//
//plot(imag(y),'r-');


// Test delay estimation
//d = delay_estim(x,y);
//printf("d = %f.\n", d);
