

//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

// add_demo("SCT", "c:/dev/scilab/comm_tbx/demos/comm_tbx.dem.gateway.sce");

function subdemolist = demo_gateway()
    demopath = get_absolute_file_path("essai_section.dem.gateway.sce");

    subdemolist = ["Graphics functions", "graphics_demo.sce"
    "Standard waveforms", "wf_demo.sce"
    "Pulse shaping filters", "psfilter_demo.sce"
    "Second order loop filter", "soopll_demo.sce"];

    subdemolist(:,2) = demopath + subdemolist(:,2);

endfunction

subdemolist = demo_gateway();
clear demo_gateway; // remove demo_gateway on stack
