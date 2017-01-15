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

// Exemple taux d'erreur binaires

lst = list();
lst(1) = wf_init('bpsk');
//lst(2) = wf_init('qpsk');
lst(2) = wf_init('psk',8);
lst(3) = wf_init('psk',16);
lst(4) = wf_init('qam',16);
lst(5) = wf_init('qam',256);
lst(6) = wf_init('fsk');

lst(1).name = 'BPSK / QPSK';
lst(2).name = '8-PSK';
lst(3).name = '16-PSK';
lst(4).name = 'QAM16';
lst(5).name = 'QAM256';
lst(6).name = 'MSK';

n = length(lst);

scf(0); clf();
EbN0_db = -2:.1:12;
EbN0 = 10 .^ (EbN0_db / 10);
legs = [];
motifs = ['-','-','-','-','-','-'];
cols = [color(0,0,128), color(0,0,255), color(0,128,255), color(255,0,0), color(255,128,0), color(0,255,0)];

for i = 1:n
    //cols(i) = [color(255*(i/n),0,0)];
    ber = lst(i).ber(EbN0);
    plot(EbN0_db, ber, motifs(i));
    legs = [legs ; lst(i).name];
end

a = gca();
e=a.children //Compound of 2 polylines
for i = 1:n
  p1=e.children(n-i+1) //the last drawn polyline properties
  //f = 255*(n-i)/n;
  p1.foreground = cols(i);//color(255,f,f);  // change the polyline color
  //e.children.thickness=5; // change the thickness of the two polylines
end

a.log_flags = 'nl';
a.title.font_size = 4;

legend(legs,3);
xgrid(color('gray'));

xtitle("Comparaison de BER (sans codage)", "$E_b/N_0$", "ber");

ccdir = get_absolute_file_path("ex-ber.sce");
xs2pdf(gcf(),ccdir+ '../../../../formations/sdr/presentation/imgqual/ex-ber.pdf');


scf(1); clf();
cols = [color(0,0,128), color(0,0,255), color(0,128,255), color(255,0,0), color(255,128,0), color(0,255,0)];
EbN0_db = -2:.1:20;
EbN0 = 10 .^ (EbN0_db / 10);
for i = 1:n
    ber = lst(i).ber(EbN0);
    plot(EbN0_db, ber, motifs(i));
end
a = gca();
e=a.children //Compound of 2 polylines
for i = 1:n
  p1=e.children(n-i+1) //the last drawn polyline properties
  //f = 255*(n-i)/n;
  p1.foreground = cols(i);//color(255,f,f);  // change the polyline color
  //e.children.thickness=5; // change the thickness of the two polylines
end

//a.log_flags = 'nl';
a.title.font_size = 4;

legend(legs);
xgrid(color('gray'));






