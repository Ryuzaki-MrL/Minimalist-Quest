#define section_load
/// section_load(x, y)

with(instance_place(argument0, argument1, obj_sectionarea)) {
    visited = true;
    section_x = x;
    section_y = y - 48;
    section_w = image_xscale * 32;
    section_h = 48 + image_yscale * 24;
    section_x2 = section_x + section_w;
    section_y2 = section_y + section_h;
}

#define section_transition
/// section_transition(x, y, direction)

with(obj_weaponhit) instance_destroy();
instance_deactivate_region(section_x, section_y, section_w, section_h, true, true);
instance_activate_object(obj_nodeactivate);
section_load(argument0, argument1);
transition = argument2;

#define is_inside
/// is_inside(x, y)

return ((argument0-section_x) >= 24) && ((section_x2-argument0) >= 24) && ((argument1-(section_y+48)) >= 24) && ((section_y2-argument1) >= 24);