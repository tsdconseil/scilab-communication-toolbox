
function ctui_label(f,c,name)
    h = uicontrol(f,'style','text','constraints',c,'string',name);
endfunction

function ctui_prmlist(f,ids,labels,values,styles,ypos,cb)
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
h.callback = cb;
end 
endfunction

function ui = ctui_openfig(id,titre,frame_w,frame_h,plot_w)
    
    // Frame width and height
    ui.frame_w = frame_w;
    ui.frame_h = frame_h;
    // Plot width and heigh
    ui.plot_w  = plot_w;
    ui.plot_h  = frame_h;
    // Horizontal and vertical margin for elements
    ui.margin_x = 15; 
    ui.margin_y = 15;
    ui.defaultfont = "arial"; // Default Font
    
    ui.axes_w = 3*ui.margin_x + ui.frame_w + ui.plot_w;// axes width
    ui.axes_h = 2*ui.margin_y + ui.frame_h; // axes height (100 => toolbar height)
    
    ui.f = scf(100001);
    ui.f.background = -2;
    ui.f.figure_position = [100 50];
    // Change dimensions of the figure
    ui.f.figure_name = titre;
    ui.f.axes_size = [ui.axes_w ui.axes_h];
    ui.f.dockable = "off";
    ui.f.infobar_visible = "off";
    ui.f.toolbar = "none";
    ui.f.menubar_visible = "off";
    ui.f.menubar = "none";
    ui.f.tag = 'main-frame';
    ui.f.userdata = ui;
    ui.frames = [];
    ui.posf = 0;
    ui.axes = list();
    
    clf();
    
    // Adding button
    huibutton = uicontrol(ui.f, "style","pushbutton", ...
    "Position",[15 20 100 20], "String","Ok", ...
    "BackgroundColor",[.9 .9 .9], "fontsize",14, ...
    "Callback",id+"_ok_callback");
    huibutton = uicontrol(ui.f, "style","pushbutton", ...
    "Position",[140 20 100 20], "String","Cancel", ...
    "BackgroundColor",[.9 .9 .9], "fontsize",14, ...
    "Callback",id+"_cancel_callback");
    
endfunction

function [ui,fr] = ctui_openframe(ui, titre, height)
    // position : y debut, largeur
    
    fr.ytop = ui.frame_h - ui.posf;
    ui.posf = ui.posf + height + ui.margin_y;
    fr.height = height;
    fr.ybot = fr.ytop - height;
    
 
fr.control = uicontrol("parent",ui.f, "relief","groove", ...
"style","frame", "units","pixels", ...
"position",[ui.margin_x fr.ybot ui.frame_w fr.height], ...
"horizontalalignment","center", "background",[1 1 1], ...
"tag","frame_control");
// Frame title
my_frame_title = uicontrol("parent",ui.f, "style","text", ...
"string",titre, "units","pixels", ...
"position",[30+ui.margin_x fr.ytop-10 ui.frame_w-60 20],...
"fontname",ui.defaultfont,"fontunits","points", ...
"fontsize",16, "horizontalalignment","center", ...
"background",[1 1 1], "tag","title_frame_control");
endfunction

function x = ctui_fieldval(tag)
    h = findobj('tag',tag);
    if(h == []) then
        error("Objet non trouve : [%s].", tag);
    end;
    x = evstr(h.string);
endfunction



