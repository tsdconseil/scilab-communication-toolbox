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



fftw_forget_wisdom(); // FIX BUG SCILAB 



//X = [0 1 2 3; 10 11 12 13]'
//X = [0 1 2 3]
//y = channelize(X,1)
//upsample(X(:,1),2) + upsample(X(:,2),2) .* ((-1) .^ (0:7)')
//fft(X,1,1)

fs = 1e3;
mod = mod_init('bpsk', fs,fi=0,fsymb=50);
[mod,x] = mod_process(mod,prbs(1000));
nchn = 8;

//x = ones(length(x),1);
X = repmat(x,1,nchn);
//X = ones(size(X,1),size(X,2)) / 1e12;

//h = [1 1 1 1 1];

//h = wfir('lp',64,[0.5/nchn,0],'hn',[0,0]);
h = ones(1,nchn);

y = channelize(X,h);

clf(); 

plot_psd(y,8*fs,'b');


cdir = get_absolute_file_path("ex_channelize.sce");
xs2png(gcf(), cdir + '../../help/en_US/channelization/ex_channelize.png');

//plot_psd(x+%i*1e-15,fs,'g');
//legend(['Signal ])
