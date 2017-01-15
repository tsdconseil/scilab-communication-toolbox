// ====================================================================
// This file is released under the 3-clause BSD license. See COPYING-BSD.
// ====================================================================
function cleanmacros()

    libpath = get_absolute_file_path("cleanmacros.sce");
    
    exec(libpath + '/list-folders.sce');

    binfiles = ls(libpath+"/*.bin");
    for i = 1:size(binfiles,"*")
        mdelete(binfiles(i));
    end
    
    mdelete(libpath+"/names");
    mdelete(libpath+"/lib");
    
    l = sct_module_list();
    for(j= 1:size(l,2))
       binfiles = ls(libpath + '/' + l(j) + "/*.bin");
        for i = 1:size(binfiles,"*")
            mdelete(binfiles(i));
        end 
        mdelete(libpath+ '/' + l(j)+"/names");
        mdelete(libpath+ '/' + l(j)+"/lib");
    end;
    
    helpdir = libpath + "/../help/fr_FR";
    mdelete(helpdir + '/master_help.xml');
    for(j= 1:size(l,2))
       binfiles = ls(helpdir + '/' + l(j) + "/*.xml");
        for i = 1:size(binfiles,"*")
            mdelete(binfiles(i));
        end 
    end;
    
    helpdir = libpath + "/../help/en_US";
    mdelete(helpdir + '/master_help.xml');
    for(j= 1:size(l,2))
       binfiles = ls(helpdir + '/' + l(j) + "/*.xml");
        for i = 1:size(binfiles,"*")
            mdelete(binfiles(i));
        end 
    end;
    


endfunction

cleanmacros();
clear cleanmacros; // remove cleanmacros on stack

// ====================================================================
