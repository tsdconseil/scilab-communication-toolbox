cdir = get_absolute_file_path("loadall.sce") + "/";

funcprot(0);

exec(cdir + '/list-folders.sce');
l = sct_module_list();

for(j= 1:size(l,2))
    scifiles = ls(cdir + '/' + l(j) + "/*.sci");
    for i = 1:size(scifiles,"*")
        //printf("Chargement %s...\n", scifiles(i));
        exec(scifiles(i));
    end 
end;

