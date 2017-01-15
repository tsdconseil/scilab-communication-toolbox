// Description
// Demonstration for various pulse shaping filters (using FIR approximations)
// Authors
//  J.A., full documentation available on www.tsdconseil.fr/log/sct

cdir = get_absolute_file_path("psfilter_demo.sce");
exec(cdir + "../macros/loadall.sce");
cdir = get_absolute_file_path("psfilter_demo.sce");
exec(cdir + "comm_tbx_ui_common.sce");


function psfilter_demo(callback)
    global ui;
ui = ctui_openfig("psf", "Pulse shaping filter demonstration",frame_w=350,frame_h=400,plot_w=600);

[ui,fr] = ctui_openframe(ui, "Paramètres", 180);

ids    = ['psf_osf','psf_ntaps','wfs_fsel','wfs_rl','wfs_bt'];
labels = ['Oversampling factor:', 'Number of taps:', 'Filter type:', 'Roll-off factor:', 'Bandwidth-time (BT):'];
values = [5, 15, 1, 0.2, 0.8];
styles = ['edit', 'edit', 'popupmenu', 'edit', 'edit'];
ctui_prmlist(ui.f,ids,labels,values,styles,ui.frame_h-20,"psfilter_callback()");
h = findobj('tag', 'wfs_fsel');
h.string = 'None|Moving average (NRZ)|Raised Cosine (RC)|Square Root RC (SRRC)|Gaussian';
h.value = 2;
if(argn(2) > 0)
  ui.user_callback = callback;
end;
psfilter_callback();
endfunction

function psfilter_callback()
    global ui;
        
    printf("psfilter_callback...\n");
    
    drawlater();
    
    h = findobj('tag', 'wfs_fsel');
    if(h == []) then
        error("Objet non trouve : wfs_sel.");
    end;
    sel = h.string(h.value);
    disp(h.value);
    disp(sel);
    
    sel = convstr(sel,'l');
    wfs_fsel = findobj('tag','wfs_fsel');
    wfs_rl = findobj('tag','wfs_rl');
    wfs_bt = findobj('tag','wfs_bt');
    wfs_rll = findobj('tag','wfs_rl_label');
    wfs_btl = findobj('tag','wfs_bt_label');
    wfs_rl.visible = 'off';
    wfs_bt.visible = 'off';
    wfs_rll.visible = 'off';
    wfs_btl.visible = 'off';
    fsel = wfs_fsel.value;
    
    osf = ctui_fieldval('psf_osf');
    ntaps = ctui_fieldval('psf_ntaps');
    
    select(fsel)
    case 1 then
        fs = 'none';
        psf = psfilter_init('none',osf,ntaps);
    case 2 then
        fs = 'nrz';
        psf = psfilter_init('nrz',osf,ntaps);
    case 3 then
        fs = 'rc';
        wfs_rl.visible = 'on';
        wfs_rll.visible = 'on';
        psf = psfilter_init('rc', osf,ntaps, ctui_fieldval('wfs_rl'));
    case 4 then
        fs = 'srrc';
        wfs_rl.visible = 'on';
        wfs_rll.visible = 'on';
        psf = psfilter_init('srrc', osf,ntaps, ctui_fieldval('wfs_rl'));
    case 5 then
        fs = 'gaussian';
        wfs_bt.visible = 'on';
        wfs_btl.visible = 'on';
        psf = psfilter_init('g', osf,ntaps, ctui_fieldval('wfs_bt'));
    else
        error('invalid filter.');
    end;
        
    for i = 1:length(ui.axes)
    if(ui.axes(i) ~= 0)
        try
        delete(ui.axes(i));
        catch
        end;
        ui.axes(i) = 0;
    end;
    end;
    
    ui.axes(1) = newaxes();
    ui.axes(1).title.font_size = 3;
    ui.axes(1).axes_bounds = [0.3,0,0.75,0.5];
    plot_rimp(psf.h');
    xtitle("Réponse impulsionnelle");
    ui.axes(2) = newaxes();
    ui.axes(2).title.font_size = 3;
    ui.axes(2).axes_bounds = [0.3,0.5,0.75,0.5];
    [xm,fr] = frmag(psf.h,[1],1024);
    plot(fr,20*log10(xm+1e-70));
    xtitle("Réponse fréquentielle", "Fréquence normalisée", "Magnitude (dB)");
    drawnow();
    ui.psf = psf;
endfunction


function psf_ok_callback()
    global ui;
    xdel(100001);
    if(isfield(ui, 'user_callback'))
      ui.user_callback('ok',ui.psf);
    end;
endfunction

function psf_cancel_callback()
    global ui;
    xdel(100001);
    if(isfield(ui, 'user_callback'))
      ui.user_callback('cancel',ui.psf);
    end;
endfunction

psfilter_demo();

