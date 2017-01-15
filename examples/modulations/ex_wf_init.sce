
wf = wf_init('qam64');
clf(); plot_const(wf);

cdir = get_absolute_file_path("ex_wf_init.sce");

xs2png(gcf(),cdir+'../../help/en_US/modulations/ex_wf_init.png');
