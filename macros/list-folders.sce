


lp = get_absolute_file_path("list-folders.sce");

function x = sct_module_list()
x = ['' 'carrier-rec' 'simulation' 'clock-rec' 'graphics' 'modulations'  'pulse-shaping' 'pulse-shaping/filters' 'pulse-shaping/misc' 'sym-gen' 'sym-gen/lfsr' 'channelization' 'limits' 'ui' 'misc' 'equalization' 'eq'];
//  
endfunction

function x = sct_function_list(root, mod)
  x = ls(root + '/' + mod + "/*.sci");
endfunction





