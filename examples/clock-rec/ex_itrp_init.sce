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

itrps = list();
cols = ['g-';'m-';'k-'];
itrps(1) = itrp_init('linear');
itrps(2) = itrp_init('cspline');
itrps(3) = itrp_init('lagrange',10);

function [y] = runge(t)
    y = 1 ./ (1 + 25 * t .^ 2);
endfunction

R = 10; // Interpolation ratio
t1 = (-1:0.2:1)';
x = runge(t);

scf(1);
clf();
subplot(211);
plot(t,x,'bs');
t2 = (-1:0.02:1)';
xv = runge(t2);
plot(t2,xv,'b-');
legs0 = ['Runge';'Runge (vraies valeurs)'];
legs  = [];
for i = 1:length(itrps)
    t2 = (-1:(0.2/R):1)';
    xp = resample(x,R,itrps(i));
    n = min(length(xp), length(t2));
    t2 = t2(1:n); xp = xp(1:n); xv = xv(1:n);
    subplot(211);
    plot(t2,xp,cols(i));
    subplot(212);
    plot(t2,xp-xv,cols(i));
    legs = [legs;itrps(i).name];
end
subplot(211); legend([legs0 ; legs]); xtitle("Interpolation");
subplot(212); legend(legs); xtitle("Erreur");

cdir = get_absolute_file_path("ex_itrp_init.sce");
xs2png(gcf(), cdir + '../../help/fr_FR/clock-rec/ex_itrp_init.png');

scf(0);
clf();
itrp = itrp_init('linear');
R = 10; // Interpolation ratio
t1 = (-1:0.2:1)';
t2 = (-1:(0.2/R):1)';
x1 = t1 .^ 2;
x2 = resample(x1,R,itrp);
plot(t1,x1,'sk');
plot(t2,x2(1:length(t2)),'b-');
legend(['$t^2$','Linear interpolation']);

xs2png(gcf(), cdir + '../../help/fr_FR/clock-rec/ex_itrp_init_simple.png');

