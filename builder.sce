// Modifié le 01-05-2015 (C) J.A. / www.tsdconseil.fr

// Copyright (C) 2008 - INRIA
// Copyright (C) 2009-2011 - DIGITEO

// This file is released under the 3-clause BSD license. See COPYING-BSD.

mode(-1);
lines(0);


//tbx_builder

//helptbx_iscontentupdte
//helptbx_updtifneeded
//helptbx_helpupdate

function main_builder()

    TOOLBOX_NAME  = "comm_tbx";
    TOOLBOX_TITLE = "Communication toolbox";
    toolbox_dir   = get_absolute_file_path("builder.sce");

    // Check Scilab's version
    // =============================================================================

    try
        v = getversion("scilab");
    catch
        error(gettext("Scilab 5.3 or more is required."));
    end

    if v(1) < 5 & v(2) < 3 then
        // new API in scilab 5.3
        error(gettext("Scilab 5.3 or more is required."));
    end

    // Check modules_manager module availability
    // =============================================================================

    if ~isdef("tbx_build_loader") then
        error(msprintf(gettext("%s module not installed."), "modules_manager"));
    end

    // Action
    // =============================================================================

    tbx_builder_macros(toolbox_dir);
    //tbx_builder_src(toolbox_dir);
    //tbx_builder_gateway(toolbox_dir);
    tbx_build_localization(TOOLBOX_NAME, toolbox_dir);
    tbx_builder_help(toolbox_dir);
    tbx_build_loader(TOOLBOX_NAME, toolbox_dir);
    tbx_build_cleaner(TOOLBOX_NAME, toolbox_dir);

endfunction
// =============================================================================
main_builder();
clear main_builder; // remove main_builder on stack
// =============================================================================


