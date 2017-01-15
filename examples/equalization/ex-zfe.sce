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

//h = [0.1 1 0.1];
h = [1 -0.2 0.1 0.05];
g = equalizer_zfe(h, 10)
//cv = convol(g,h)'

x0 = nrz(prbs(14),3);
x1 = convol(h,x0);
x2 = convol(g,x1);

clf(); 
subplot(311);
plot(x0, 'ob-');
xtitle("Signal original (x0)");
a = gca();
a.title.font_size = 4;
a.data_bounds = [0,-1.3;40,1.3];
subplot(312);
plot(x1, 'ob-');
xtitle("Après canal (x1)");
a = gca();
a.title.font_size = 4;
a.data_bounds = [0,-1.3;40,1.3];
subplot(313);
plot(x2, 'ob-');
xtitle("Après égalisation ZFE (x2)");
a = gca();
a.title.font_size = 4;
a.data_bounds = [0,-1.3;40,1.3];
cdir = get_absolute_file_path("ex-zfe.sce");
//xs2png(gcf(), cdir + '../../help/en_US/equalization/ex-zfe.png');
//xs2pdf(gcf(), 'c:/dev/formations/sdr/presentation/img2/ex-zfe.pdf');


