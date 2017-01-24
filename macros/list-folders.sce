


lp = get_absolute_file_path("list-folders.sce");

function x = sct_module_list()
x = ['' 'carrier-rec' 'simulation' 'clock-rec' 'graphics' 'modulations'  'pulse-shaping' 'pulse-shaping/filters' 'sym-gen' 'sym-gen/lfsr' 'channelization' 'limits' 'ui' 'misc' 'equalization' 'equalization'];
//  
endfunction

function x = sct_function_list(root, mod)
  x = ls(root + '/' + mod + "/*.sci");
endfunction





