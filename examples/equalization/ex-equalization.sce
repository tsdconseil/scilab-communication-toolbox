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

fs = 4; fi = 0; fsymb = 1;
grand("setsd", 1234567);

wf = wf_init('qpsk');

eq1 = equalizer_init(wf, fs/fsymb, 'slicer', 'dde', 0.075, 21);
eq2 = equalizer_init(wf, fs/fsymb, 'slicer', 'dfe', 0.01, 21, 21);
eq3 = equalizer_init(wf, fs/fsymb, 'cma', 'dde', 0.01,21);
eq4 = equalizer_init(wf, fs/fsymb, 'cma', 'dfe', 0.01,21);

lst = list(eq1, eq2, eq3, eq4);
neq = length(lst);

h = [1 0.1 -.1 0.15 0.05];
h = h ./ sum(h);
n = 2000;
mod = mod_init(wf, fs,fi,fsymb);
[mod,x] = mod_process(mod,prbs(n));
x = x(10:$);
y = convol(h,x);
y = y(1:$-20);
n = length(y);
y = awgn(y, 0.02, 'c');

E = list();
Z = list();

for i = 1:neq
    [lst(i),z,err] = equalizer_process(lst(i), y);
    E(i) = err;
    Z(i) = z;
    rms_final(i) = sqrt(mean(err($-100:$) .* err($-100:$)));
end


for i = 1:neq
    nom = lst(i).structure + ' / ' + lst(i).errf;
    printf("%s : RMS = %.8f\n", nom, rms_final(i));
scf(i); clf();
subplot(411);
nf = length(x);
plot(x(1:$),'c-');
xtitle(nom + ' (entrée)');
subplot(412);
plot(y(1:$),'m-');
xtitle('Sortie canal');
subplot(413);
zz = Z(i);
plot(zz(1:$),'b-');
xtitle('Egalisation');
subplot(414);
ee = E(i);
plot(ee(1:$),'b-');
xtitle("Erreur");

xs2pdf(gcf(), 'c:/dev/formations/sdr/presentation/egalisation/ex-' + lst(i).structure + '-' + lst(i).errf + '.pdf');
xs2png(gcf(), 'c:/dev/scilab/comm_tbx/help/en_US/equalization/ex-' + lst(i).structure + '-' + lst(i).errf + '.png');

end

for i = 1:neq
scf(neq+i); clf();
subplot(131);
plot_const(x);
xtitle("Avant canal");
a = gca(); a.title.font_size = 4;
subplot(132);
plot_const(y);
xtitle("Après canal");
a = gca(); a.title.font_size = 4;
subplot(133);
plot_const(Z(i));
xtitle("Après égalisation");
a = gca(); a.title.font_size = 4;
xs2png(gcf(), 'c:/dev/formations/sdr/presentation/egalisation/ex-' + lst(i).structure + '-' + lst(i).errf + '-const.png');
xs2png(gcf(), 'c:/dev/scilab/comm_tbx/help/en_US/equalization/ex-' + lst(i).structure + '-' + lst(i).errf + '-const.png');
end;
