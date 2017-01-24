// BUILD HELP / EN

TOOLBOX_TITLE = 'comm_tbx';

helpdir = get_absolute_file_path("build_help.sce");
macrosdir = helpdir + '../../macros';
demosdir = [];
modulename = "comm_tbx";

//////////////////
// (1) Construit ou met à jour les fichier XML
//////////////////

exec(helpdir + '/../../macros/list-folders.sce');

//helptbx_helpupdate('bidon', helpdir, macrosdir, demosdir , modulename , %t);

mods = sct_module_list();

for i=1:size(mods,'*')
  files = ls(macrosdir + '/' + mods(i) + '/*.sci');
  for(j = 1:size(files,'*'))
    file = basename(files(j));
    files(j) = file;
  end;
  if(size(files,'*') == 0) then
      printf("Pas de macros trouvée dans le dossize %s.\n", mods(i));
  else
  printf("Mise à jour de l''aide dans %s...\n", mods(i));
  //disp(files');
  helptbx_helpupdate(files, helpdir + mods(i), macrosdir + '/' + mods(i), demosdir , modulename , %t);
  end;
end;


//////////////////
// (2) Génération HTML
//////////////////

printf("***** Generation HTML...\n");
helpdir = get_absolute_file_path("build_help.sce");
tbx_build_help(TOOLBOX_TITLE, helpdir);
printf("***** Copie vers dossier site web...\n");
[st,msg] = copyfile(helpdir + '/scilab_en_US_help', 'c:/dev/site/data/sct-dox-en');
if(st == 0)
    printf("Echec de la copie : %s.\n", msg);
else
    printf("Copie ok.\n");
end;
printf("Terminé.\n");




//////////////////////////
// ESSAI
//help_dir    = helpdir + '/limits';
//help_title  = 'Communication toolbox';
//html_dir    = xmltohtml(help_dir,help_title,'en_US');
//








