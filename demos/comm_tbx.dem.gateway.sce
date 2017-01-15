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

// add_demo("SCT", "c:/dev/scilab/comm_tbx/demos/comm_tbx.dem.gateway.sce");

function subdemolist = demo_gateway()
    demopath = get_absolute_file_path("comm_tbx.dem.gateway.sce");

    subdemolist = ["Graphics functions", "graphics/graphics.dem.gateway.sce"
	"Carrier recovery", "carrier-rec/carrier-rec.dem.gateway.sce"
	"Channelization", "channelization/channelization.dem.gateway.sce"
	"Clock recovery", "clock-rec/clock-rec.dem.gateway.sce"
	"Equalization", "equalization/equalization.dem.gateway.sce"
	"Limits", "limits/limits.dem.gateway.sce"
	"Misc", "misc/misc.dem.gateway.sce"
	"Modulations", "modulations/modulations.dem.gateway.sce"
	"Pulse shaping", "pulse-shaping/pulse-shaping.dem.gateway.sce"
	"Simulation", "simulation/simulation.dem.gateway.sce"];
//    "Standard waveforms", "wf_demo.sce"
//    "Pulse shaping filters", "psfilter_demo.sce"
//    "Second order loop filter", "soopll_demo.sce"
//    "Essai section", "essai_section.dem.gateway.sce"];

    subdemolist(:,2) = demopath + subdemolist(:,2);
    
    add_demo("SCT", demopath + "comm_tbx.dem.gateway.sce");

endfunction

subdemolist = demo_gateway();
clear demo_gateway; // remove demo_gateway on stack
