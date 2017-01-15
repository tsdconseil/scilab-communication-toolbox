// Scilab Communication Toolbox
// (C) J.A. / contact: http://www.tsdconseil.fr 
//
// Ce logiciel est régi par la licence CeCILL-C soumise au droit français et
// respectant les principes de diffusion des logiciels libres. Vous pouvez
// utiliser, modifier et/ou redistribuer ce programme sous les conditions
// de la licence CeCILL-C telle que diffusée par le CEA, le CNRS et l'INRIA 
// sur le site "http://www.cecill.info".
//
// En contrepartie de l'accessibilité au code source et des droits de copie,
// de modification et de redistribution accordés par cette licence, il n'est
// offert aux utilisateurs qu'une garantie limitée.  Pour les mêmes raisons,
// seule une responsabilité restreinte pèse sur l'auteur du programme,  le
// titulaire des droits patrimoniaux et les concédants successifs.
//
// A cet égard  l'attention de l'utilisateur est attirée sur les risques
// associés au chargement,  à l'utilisation,  à la modification et/ou au
// développement et à la reproduction du logiciel par l'utilisateur étant 
// donné sa spécificité de logiciel libre, qui peut le rendre complexe à 
// manipuler et qui le réserve donc à des développeurs et des professionnels
// avertis possédant  des  connaissances  informatiques approfondies.  Les
// utilisateurs sont donc invités à charger  et  tester  l'adéquation  du
// logiciel à leurs besoins dans des conditions permettant d'assurer la
// sécurité de leurs systèmes et ou de leurs données et, plus généralement, 
// à l'utiliser et l'exploiter dans les mêmes conditions de sécurité. 
//
// Le fait que vous puissiez accéder à cet en-tête signifie que vous avez 
// pris connaissance de la licence CeCILL-C, et que vous en avez accepté les
// termes.


function wfselector(callback)
// User interface for waveform selection
//
// Calling Sequence
// wfselector(callback)
//
//  Parameters
//  callback: Callback function called when the user has finished. The callback will be called with 2 parameters: status ('ok' if the user has pressed ok, 'cancel' otherwise), and wf (waveform object, as selected and configured by the user).
//
// Examples
// function mycallback(status,wf)
// // ...
// endfunction
// wfselector(mycallback);
//
// Authors
//  J.A., full documentation available on <ulink url="http://www.tsdconseil.fr/log/sct">http://www.tsdconseil.fr/log/sct</ulink>

global wfs_user_callback
wfs_user_callback = callback;

function label(f,c,name)
    h = uicontrol(f,'style','text','constraints',c,'string',name);
endfunction

function prmlist(f,ids,labels,values,styles,ypos)
// positioning
l1 = 30; l2 = 160; l3 = 170;
for k=1:size(labels,2)
uicontrol("parent",f, "style","text",...
"string",labels(k), "position",[l1,ypos-k*30,l2,25], ...
"horizontalalignment","left", "fontsize",14, ...
"background",[1 1 1], 'tag', ids(k) + '_label');
h = uicontrol("parent",f, "style",styles(k),...
"string",string(values(k)), 'value', values(k), "position",[l3,ypos-k*30,180,25], ...
"horizontalalignment","left", "fontsize",14, ...
"background",[.9 .9 .9], "tag",ids(k));
h.callback = "wfs_callback()";
end 
endfunction


//drawlater();

// Window Parameters initialization
frame_w = 350; frame_h = 320;// Frame width and height
plot_w = 700; plot_h = frame_h;// Plot width and heigh
margin_x = 15; margin_y = 15;// Horizontal and vertical margin for elements
defaultfont = "arial"; // Default Font
axes_w = 3*margin_x + frame_w + plot_w;// axes width
axes_h = 2*margin_y + 2 * frame_h; // axes height (100 => toolbar height)

f = scf(100001);
f.background = -2;
f.figure_position = [100 50];
// Change dimensions of the figure
f.figure_name = "Waveform selection";
f.axes_size = [axes_w axes_h];
f.dockable = "off";
f.infobar_visible = "off";
f.toolbar = "none";
f.menubar_visible = "off";
f.menubar = "none";

clf();
my_frame = uicontrol("parent",f, "relief","groove", ...
"style","frame", "units","pixels", ...
"position",[ margin_x margin_y+300+50 frame_w frame_h-50], ...
"horizontalalignment","center", "background",[1 1 1], ...
"tag","frame_control");
// Frame title
my_frame_title = uicontrol("parent",f, "style","text", ...
"string","Waveform parameters", "units","pixels", ...
"position",[30+margin_x margin_y+frame_h-10+300 frame_w-60 20],...
"fontname",defaultfont, "fontunits","points", ...
"fontsize",16, "horizontalalignment","center", ...
"background",[1 1 1], "tag","title_frame_control");


ids    = ['wfs_sel','wfs_k','wfs_mi','wfs_K1','wfs_K2'];
labels = ['Waveform type:', 'Bits / symbol:', 'Modulation index:', 'Min. level:', 'Gain:'];
values = [1, 1, 0.5, -1, 2];
styles = ['popupmenu', 'spinner', 'edit', 'edit', 'edit'];

prmlist(f,ids,labels,values,styles,frame_h+280);

wfs_k  =findobj('tag', 'wfs_k');
wfs_k.min = 1;
wfs_k.max = 8;
wfs_k.sliderstep = 1;

h = findobj('tag', 'wfs_sel');
h.string = convstr('ask|ook|bpsk|qpsk|8psk|qam|fsk|msk', 'u');
h.value = 4;



my_frame = uicontrol("parent",f, "relief","groove", ...
"style","frame", "units","pixels", ...
"position",[ margin_x margin_y+30+50 frame_w frame_h-20-50], ...
"horizontalalignment","center", "background",[1 1 1], ...
"tag","frame_control2");
// Frame title
my_frame_title = uicontrol("parent",f, "style","text", ...
"string","Pulse shaping filter", "units","pixels", ...
"position",[30+margin_x margin_y+frame_h-10-20+30 frame_w-60 20],...
"fontname",defaultfont, "fontunits","points", ...
"fontsize",16, "horizontalalignment","center", ...
"background",[1 1 1], "tag","title_frame_control2");

ids    = ['wfs_fsel','wfs_ntaps','wfs_rl','wfs_bt'];
labels = ['Filter type:', 'Number of filter taps', 'Roll-off factor:', 'Bandwidth-time (BT):'];
values = [1, 64, 0.2, 0.8];
styles = ['popupmenu', 'edit', 'edit', 'edit'];
prmlist(f,ids,labels,values,styles,frame_h-20);
h = findobj('tag', 'wfs_fsel');
h.string = 'None|Moving average (NRZ)|Raised Cosine (RC)|Square Root RC (SRRC)|Gaussian';
h.value = 2;

// Adding button
huibutton = uicontrol(f, "style","pushbutton", ...
"Position",[15 20 100 20], "String","Ok", ...
"BackgroundColor",[.9 .9 .9], "fontsize",14, ...
"Callback","wfs_ok_callback");
huibutton = uicontrol(f, "style","pushbutton", ...
"Position",[140 20 100 20], "String","Cancel", ...
"BackgroundColor",[.9 .9 .9], "fontsize",14, ...
"Callback","wfs_cancel_callback");

wfs_callback();
endfunction

function wfs_callback()
    global wfs_a1 wfs_a2 wfs_wf
    
    function x = fieldval(tag)
        h = findobj('tag',tag);
        x = evstr(h.string);
    endfunction
    
    printf("My callback.\n");
    h = findobj('tag', 'wfs_sel');
    sel = h.string(h.value);
    disp(h.value);
    disp(sel);
    
    sel = convstr(sel,'l');
    
    //s1 = fieldval('wfs_sel');
    //k = fieldval('wfs_k');
    K1 = fieldval('wfs_K1');
    K2 = fieldval('wfs_K2');
    mi = fieldval('wfs_mi');

    
    

    wfs_k  =findobj('tag', 'wfs_k');
    k = wfs_k.value;
    M = 2^k;
    printf("k, K1, K2: ");
    disp([k, K1, K2]);
    wfs_K1 = findobj('tag', 'wfs_K1');
    wfs_K2 = findobj('tag', 'wfs_K2');
    wfs_K1l = findobj('tag', 'wfs_K1_label');
    wfs_K2l = findobj('tag', 'wfs_K2_label');
    wfs_K1.enable = 'off';
    wfs_K2.enable = 'off';
    wfs_K1.visible = 'off';
    wfs_K2.visible = 'off';
    wfs_K1l.visible = 'off';
    wfs_K2l.visible = 'off';
    wfs_k.enable = 'off';
    wfs_mi = findobj('tag','wfs_mi');
    wfs_mil = findobj('tag','wfs_mi_label');
    wfs_mi.visible = 'off';
    wfs_mil.visible = 'off';
    
    wfs_fsel = findobj('tag','wfs_fsel');
    wfs_rl = findobj('tag','wfs_rl');
    wfs_bt = findobj('tag','wfs_bt');
    wfs_rll = findobj('tag','wfs_rl_label');
    wfs_btl = findobj('tag','wfs_bt_label');
    wfs_ntaps = findobj('tag','wfs_ntaps');
    wfs_ntapsl = findobj('tag','wfs_ntaps_label');
    wfs_rl.visible = 'off';
    wfs_bt.visible = 'off';
    wfs_rll.visible = 'off';
    wfs_btl.visible = 'off';
    wfs_ntapsl.visible = 'off';
    wfs_ntaps.visible = 'off';
    fsel = wfs_fsel.value;
    
    
    
    select(sel)
    case 'ask' then 
        wf = wf_init(sel,M,K1,K2);
        wfs_K1.enable = 'on';
        wfs_K2.enable = 'on';
        wfs_K1.visible = 'on';
        wfs_K2.visible = 'on';
        wfs_K1l.visible = 'on';
        wfs_K2l.visible = 'on';
        wfs_k.enable = 'on';
    case 'ook' then
        wfs_k.value = 1;
        wf = wf_init(sel);
    case 'bpsk' then
        wfs_k.value = 1;
        wf = wf_init(sel);
    case 'qpsk' then
        wfs_k.value = 2;
        wf = wf_init(sel);
    case '8psk' then
        wfs_k.value = 3;
        wf = wf_init(sel);
    case 'qam' then
        wfs_k.enable = 'on';
        if((k < 4) | (modulo(k,2) ~= 0)) 
            wfs_k.value = 4;
            k = 4;
            M = 16;
        end;
        wf = wf_init(sel,M);
    case 'msk' then
        wfs_k.enable = 'on';
        wf = wf_init(sel);
        wfs_mi.enable = 'off';
        wfs_mi.visible = 'on';
        wfs_mil.visible = 'on';
        wfs_mi.string = '0.5';
    case 'fsk' then
        wfs_k.enable = 'on';
        wf = wf_init('fsk',M,mi);
        wfs_mi.enable = 'on';
        wfs_mi.visible = 'on';
        wfs_mil.visible = 'on';
    else
        wf = wf_init(sel);
    end
    
    select(fsel)
    case 1 then
        fs = 'none';
        wf = wf_set_filter(wf,'none');
    case 2 then
        fs = 'nrz';
        wf = wf_set_filter(wf,'nrz');
    case 3 then
        fs = 'rc';
        wfs_ntaps.visible = 'on';
        wfs_ntapsl.visible = 'on';
        wfs_rl.visible = 'on';
        wfs_rll.visible = 'on';
        wf = wf_set_filter(wf,'rc',fieldval('wfs_ntaps'),fieldval('wfs_rl'));
    case 4 then
        fs = 'srrc';
        wfs_ntaps.visible = 'on';
        wfs_ntapsl.visible = 'on';
        wfs_rl.visible = 'on';
        wfs_rll.visible = 'on';
        wf = wf_set_filter(wf,'srrc',fieldval('wfs_ntaps'),fieldval('wfs_rl'));
    case 5 then
        fs = 'gaussian';
        wfs_ntaps.visible = 'on';
        wfs_ntapsl.visible = 'on';
        wfs_bt.visible = 'on';
        wfs_btl.visible = 'on';
        wf = wf_set_filter(wf,'gaussian',fieldval('wfs_ntaps'),fieldval('wfs_bt'));
    else
        error('invalid filter.');
    end;
    
    drawlater();
    
    if(exists('wfs_a1'))
    if(wfs_a1 ~= 0)
       try
       delete(wfs_a1);
       catch
       end
       wfs_a1 = 0;
    end;
    end;
    if(exists('wfs_a2'))
    if(wfs_a2 ~= 0)
      try
      delete(wfs_a2);
      catch
      end
      wfs_a2 = 0;
    end;
    end;
    //delete(gca());
    wfs_a1 = newaxes();
    
    //disp())
    
    //subplot(311);
    plot_const(wf);
    
    wfs_a1.title.font_size = 3;
    wfs_a1.axes_bounds = [0.3,0,0.75,0.6];
    
    wfs_a2 = newaxes();
    wfs_a2.title.font_size = 3;
    wfs_a2.axes_bounds = [0.3,0.6,0.75,0.4];
    
    
    fs      = 1e4;
    fsymb   = 100;
    fi      = 3e2;
    
    mod = mod_init(wf,fs,fi,fsymb);
    grand('setsd', 554133);
    b = prbs(20);
    
    if(sel == 'qam')
        b = prbs(40);
    end;
    
    [mod,x] = mod_process(mod,b);
    t = linspace(0,10/wfs_k.value,length(x))';
    plot(t,x);
    xtitle('Modulated signal','Symboles');
    
    drawnow();
    
    wfs_wf = wf;
endfunction


function wfs_ok_callback()
    global wfs_user_callback wfs_wf
    xdel(100001);
    wfs_user_callback('ok',wfs_wf);
endfunction

function wfs_cancel_callback()
    global wfs_user_callback wfs_wf
    xdel(100001);
    wfs_user_callback('cancel',wfs_wf);
endfunction


//function bidon_cb(status,wf)
//    printf("bidon called: status = %s.\n", status);
//endfunction
//
//wf = wfselector(bidon_cb);
//
