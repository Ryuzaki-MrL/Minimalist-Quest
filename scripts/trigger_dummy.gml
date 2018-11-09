#define trigger_dummy


#define trigger_wall
var wall = argument0;
with(wall+1) {
    check = true;
}
with(wall) {
    instance_destroy();
    with(instance_create(x,y,wall+1)) check = false;
}
with(wall+1) {
    if (check) {
        instance_destroy();
        instance_create(x,y,wall);
    }
}
with(obj_switch) {
    triggers[tg] = false;
}

#define trigger_weight_door
with(obj_eventgate) {
    if (gt == argument0) {
        y = ystart * triggers[other.tg];
    }
}

#define trigger_create_bridge
with(obj_eventhole) {
    if (tg == other.tg) instance_destroy();
}

#define trigger_open_door
with(obj_eventgate) {
    if (gt == argument0) instance_destroy();
}

#define trigger_conveyor_start
with(obj_conveyor) {
    image_speed = argument0;
}
with(obj_enemy) {
    if (place_meeting(x, y, obj_conveyor)) {
        with(instance_create(x,y-16,obj_popup)) {
            str = "?";
            color = c_white;
        }
    }
}

#define trigger_conveyor_direction
with(obj_conveyor) {
    image_speed *= -1;
}