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

// Comparaison des différentes méthodes de délais fractionnaire


n = 51;
x = [zeros(n/2,1); 1; zeros(n/2,1)];

lst = list();


lst(1) = itrp_init('lagrange',1);
lst(2) = itrp_init('lagrange',3);//itrp_init();
lst(3) = itrp_init('lagrange',7);

cols = ['g';'b';'m'];
nt = 3;

lst(1).name = 'Linéaire';

//
//y1 = frac_delay(x, 0.5, itrp1);
//itrp2 = itrp_init('lagrange',1);
//y2 = frac_delay(x, 0.5, itrp2);
//itrp2 = itrp_init('lagrange',1);
//y2 = frac_delay(x, 0.5, itrp2);
//
//plot(x);
clf();
subplot(211);
y = list();
legs = [];
for i=1:nt
    y(i) = frac_delay(x, 0.5, lst(i));
    plot(y(i),cols(i));
    legs = [legs; lst(i).name];
end
//plot(y1,'b-s');
//plot(y2,'g-o');
//legend(['Cspline','Lagrange']);
legend(legs);
xtitle("Réponse impulsionnelle");

subplot(212);
for i=1:nt
    [xm,fr] = frmag(y(i),512);
    plot(fr,xm,cols(i));
end;
//[xm1,fr1] = frmag(y1,512);
//plot(fr1,xm1,'b-');
//[xm2,fr2] = frmag(y2,512);
//plot(fr2,xm2,'g-');
//legend(['Cspline','Lagrange']);
xtitle("Réponse fréquentielle");
legend(legs);


cdir = get_absolute_file_path("bench-frac-delay.sce");
//xs2png(gcf(), cdir + '../../help/fr_FR/clock-rec/bench-frac-delay.png');
xs2pdf(gcf(), "c:/dev/formations/sdr/presentation/img2/clock/bench-frac-delay.pdf');

