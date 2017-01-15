cdir = get_absolute_file_path("test_all.sce");

funcprot(0);


function test_folder(fld)
    //scifiles = ls(cdir + '/' + l(j) + "/*.tst");
    scifiles = ls(fld + "/*.tst");
    for i = 1:size(scifiles,"*")
      printf("Exécution test %s...\n", scifiles(i));
      exec(scifiles(i));
    end;
    scifiles = dir(fld);
    estdir = scifiles.isdir;
    nom    = scifiles.name;
    
    for i = 1:size(estdir,"*")
      if(estdir(i))
        printf("Dossier %s...\n", nom(i));
        test_folder(fld + '/' + nom);
      end;
    end;

endfunction

test_folder(cdir + 'nonreg_tests');
test_folder(cdir + 'unit_tests');

//exec(cdir + '/list-folders.sce');
//l = ['nonreg_tests';



