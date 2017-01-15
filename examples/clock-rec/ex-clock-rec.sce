
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

curdir = get_absolute_file_path("ex-clock-rec.sce");
exec(curdir + "../../macros/loadall.sce");

function exemple_scurve()
[tau,s]=scurve(ted_el()); 
clf();
plot(tau,s);
xtitle("Gardner TED: S-curve");
xs2pdf(gcf(), "scurve-gardner.pdf");
endfunction;

grand('setsd', 4648721);

// K2 = ratio entre TED et f de sortie
osf = 50;
//K2 = 2;
cr = clock_rec_init(osf,ted_init(),itrp_init(),2);

nsymb = 100;

x = ma(nrz(prbs(nsymb),osf),osf);

// Apply a fractionnal delay
//x = x(3*osf/4:$);
x = frac_delay(x, 12.5);

scf(0);
clf();
subplot(311);
t1 = linspace(0,nsymb,length(x))';
plot(t1,x);

[cr,y,dbg] = clock_rec_process(cr,x);

printf("Erreur de phase à la fin : %f %%.\n", 100 * dbg.e($))

t2 = linspace(0,nsymb,length(y))';
plot(t2,y,'m');

legend(['Initial sampling points';'After clock recovery'])

subplot(312);
plot(dbg.e,'r');
xtitle("Phase error (TED)");


subplot(313);
plot(dbg.mu,'b');
xtitle("Phase");

 
