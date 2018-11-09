#define minimap_generate
/// minimap_generate()

var s = surface_create(256, 192);
surface_set_target(s);
draw_clear(c_white);
draw_set_color(c_black);
with(obj_sectionarea) {
    var rx = (x div 320) * 16;
    var ry = ((y-1008) div 240) * 12;
    draw_rectangle(rx, ry, rx + 16*(image_xscale/10), ry + 12*(image_yscale/10), 1);
}
surface_reset_target();
surface_save(s, "minimap_"+string(room)+".png");

#define dump_tilemap
/// dump_tilemap()

var ww = 180, hh = 90, arr, tlmp;
arr[(ww * hh) - 1] = 0;
tlmp = tile_get_ids();

var f = file_bin_open("room"+string(room)+".bin", 1);

for (var i = 0; i < array_length_1d(tlmp); ++i) {
    var xx = tile_get_x(tlmp[i]);
    var yy = tile_get_y(tlmp[i]);
    var tid = (tile_get_top(tlmp[i])/16)*4 + (tile_get_left(tlmp[i])/16);
    tid += 16 * (tile_get_background(tlmp[i])==bg_tileset2);
    if (position_meeting(xx,yy,obj_solid) && !position_meeting(xx,yy,obj_chest)) {
        tid |= 64;
    }
    arr[((yy - 3408)/16)*ww + (xx/16)] = tid;
}
with(obj_hole) {
    arr[((y-3408)/16)*ww + (x/16)] = $7F;
}
with(obj_whitefill) {
    for (var j = ((y-3408)/16); j < ((y-3408)/16) + image_yscale; ++j) {
        for (var i = (x/16); i < (x/16) + image_xscale; ++i) {
            if (arr[j*ww + i] == 0) arr[j*ww + i] = $5E;
        }
    }
}
with(obj_eventhole) {
    for (var j = ((y-3408)/16); j < ((y-3408)/16) + image_yscale; ++j) {
        for (var i = (x/16); i < (x/16) + image_xscale; ++i) {
            if (arr[j*ww + i] == $5D) arr[j*ww + i] = $1D;
        }
    }
}

for (var i = 0; i < array_length_1d(arr); ++i) {
    file_bin_write_byte(f, arr[i]);
}

file_bin_close(f);

#define dump_spritedata
/// dump_spritedata()

var ft = file_text_open_write("spritedata.txt");
var fs = file_text_open_write("sprites.t3s");
var fb = file_bin_open("spritedata.bin", 1);
var tstr, idx = 0;

for (var s = 0; sprite_exists(s); ++s) {
    var tstr = "{" +
        "sprites_" + sprite_get_name(s) + "_0_idx," +
        string(sprite_get_number(s)) + "," +
        string(sprite_get_xoffset(s)) + "," +
        string(sprite_get_yoffset(s)) + ",{" +
        string(sprite_get_bbox_left(s)) + "," +
        string(sprite_get_bbox_right(s)) + "," +
        string(sprite_get_bbox_top(s)) + "," +
        string(sprite_get_bbox_bottom(s)) +
    "}},";
    
    file_text_write_string(ft, tstr);
    file_text_writeln(ft);
    
    for (var i = 0; i < sprite_get_number(s); ++i) {
        file_text_write_string(fs, sprite_get_name(s) + "_" + string(i) + ".png");
        file_text_writeln(fs);
    }
    
    file_bin_write_byte(fb, idx);
    file_bin_write_byte(fb, sprite_get_number(s));
    file_bin_write_byte(fb, sprite_get_xoffset(s));
    file_bin_write_byte(fb, sprite_get_yoffset(s));
    file_bin_write_byte(fb, sprite_get_bbox_left(s));
    file_bin_write_byte(fb, sprite_get_bbox_right(s));
    file_bin_write_byte(fb, sprite_get_bbox_top(s));
    file_bin_write_byte(fb, sprite_get_bbox_bottom(s));
    idx += sprite_get_number(s);
}

file_text_close(ft);
file_text_close(fs);
file_bin_close(fb);

#define dump_objdata
/// dump_objdata()

instance_activate_all();

var of = file_bin_open("objdata.bin", 1);
with(all) {
    var oid = -1;
    if (object_is_ancestor(object_index, obj_eventwall)) {
        oid = obj_eventwallasgate;
    } else switch(object_index) {
        case obj_eventhole: oid = obj_eventwallasgate; break;
        case obj_eventconveyor: oid = obj_conveyor; break;
        default: if (object_index < obj_particle) oid = object_index; break;
    }
    if (oid != -1) {
        file_bin_write_byte(of, oid);
        file_bin_write_word(of, 2, false, x);
        file_bin_write_word(of, 2, false, y);
    }
}
file_bin_close(of);