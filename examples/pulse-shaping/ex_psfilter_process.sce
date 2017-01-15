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

// Gaussian filter, 16 samples/symbol, 3*16 taps FIR, B.T. = 0.5
osf = 16;
ntaps = 3 * osf;
BT = 0.5;
//psf = psfilter_init('g', osf, ntaps, BT);
psf = psfilter_init('srrc', osf, ntaps, 0.2);
b = prbs(20); // Binary sequence to be encoded
x = symmap(b,1,'b'); // NRZ encoding
x = upsample(x, osf);
[psf,y] = psfilter_process(psf,x);
clf();  
subplot(211); plot_binary(b);  xtitle("Input signal (binary)");
subplot(212); plot(y); xtitle("Filtered signal");

xs2png(gcf(), 'c:/dev/scilab/comm_tbx/help/en_US/pulse-shaping/ex-psfilter_process.png');

