// This file is released under the 3-clause BSD license. See COPYING-BSD.


lpp = get_absolute_file_path("buildmacros.sce");
exec(lpp + "/list-folders.sce");

function buildmacros()
    macros_path = get_absolute_file_path("buildmacros.sce");
    
    lst = sct_module_list();

    for i=1:size(lst,'*')
        tbx_build_macros(TOOLBOX_NAME, macros_path + lst(i));
    end
    
    //tbx_build_macros(TOOLBOX_NAME, macros_path);
//    tbx_build_macros(TOOLBOX_NAME, macros_path + 'carrier-rec');
//    tbx_build_macros(TOOLBOX_NAME, macros_path + 'simulation');
//    tbx_build_macros(TOOLBOX_NAME, macros_path + 'clock-rec');
//    tbx_build_macros(TOOLBOX_NAME, macros_path + 'graphics');
//    tbx_build_macros(TOOLBOX_NAME, macros_path + 'modulations');
//    tbx_build_macros(TOOLBOX_NAME, macros_path + 'pulse-shaping');
//    tbx_build_macros(TOOLBOX_NAME, macros_path + 'sym-gen');
//    tbx_build_macros(TOOLBOX_NAME, macros_path + 'ui');
//    tbx_build_macros(TOOLBOX_NAME, macros_path + 'misc');
//    tbx_build_macros(TOOLBOX_NAME, macros_path + 'limits');
endfunction

buildmacros();
clear buildmacros; // remove buildmacros on stack

