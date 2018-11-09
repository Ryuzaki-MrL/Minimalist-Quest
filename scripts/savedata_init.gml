#define savedata_init
/// savedata_init()

for (i = 0; i < WEAPON_COUNT; ++i) {
    weapon_level[i] = 0;
}
for (i = 0; i < ITEM_COUNT; ++i) {
    inventory[i] = 0;
}
for (i = 0; i < CHEST_COUNT; ++i) {
    chests[i] = false;
}
for (i = 0; i < TIMELINE_COUNT; ++i) {
    events[i] = false;
}
for (i = 0; i < ROOM_COUNT; ++i) {
    maps[i] = false;
}
for (i = 0; i < GATE_COUNT; ++i) {
    gates[i] = false;
}
for (i = 0; i < TRIGGER_COUNT; ++i) {
    triggers[i] = false;
}
checkpoint = 0;
curhp = 10;
maxhp = 10;
keys = 0;
friends = 0;
skill = 0;
weapon = 0;
item = 0;

#define savedata_load
/// savedata_load()

if (!file_exists("user.sav")) return 0;

var file = file_bin_open("user.sav", 0), i;

for (i = 0; i < WEAPON_COUNT; ++i) {
    weapon_level[i] = clamp(file_bin_read_byte(file), 0, 99);
}
for (i = 0; i < ITEM_COUNT; ++i) {
    inventory[i] = clamp(file_bin_read_byte(file), 0, 99);
}
chests = file_bin_read_flag_array(file, CHEST_COUNT);
events = file_bin_read_flag_array(file, TIMELINE_COUNT);
maps = file_bin_read_flag_array(file, ROOM_COUNT);
gates = file_bin_read_flag_array(file, GATE_COUNT);
triggers = file_bin_read_flag_array(file, TRIGGER_COUNT);
var rm = file_bin_read_byte(file);
if (!room_exists(rm)) {
    file_bin_close(file);
    return 0;
}

checkpoint = file_bin_read_byte(file);
keys = file_bin_read_byte(file);
friends = file_bin_read_byte(file);
curhp = clamp(file_bin_read_byte(file), 0, 20);
maxhp = clamp(file_bin_read_byte(file), 10, 20);
skill = file_bin_read_byte(file);
skill = (skill << 8) | file_bin_read_byte(file);
skill = (skill << 8) | file_bin_read_byte(file);
skill = (skill << 8) | file_bin_read_byte(file);
weapon = file_bin_read_byte(file);
item = file_bin_read_byte(file);
room_goto(rm);

file_bin_close(file);
return 1;

#define savedata_save
/// savedata_save(checkpoint)

var file = file_bin_open("user.sav", 1), i;

for (i = 0; i < WEAPON_COUNT; ++i) {
    file_bin_write_byte(file, weapon_level[i]);
}
for (i = 0; i < ITEM_COUNT; ++i) {
    file_bin_write_byte(file, inventory[i]);
}
file_bin_write_flag_array(file, chests, CHEST_COUNT);
file_bin_write_flag_array(file, events, TIMELINE_COUNT);
file_bin_write_flag_array(file, maps, ROOM_COUNT);
file_bin_write_flag_array(file, gates, GATE_COUNT);
file_bin_write_flag_array(file, triggers, TRIGGER_COUNT);
file_bin_write_byte(file, room);
file_bin_write_byte(file, argument0);
file_bin_write_byte(file, keys);
file_bin_write_byte(file, friends);
file_bin_write_byte(file, curhp);
file_bin_write_byte(file, maxhp);
file_bin_write_byte(file, skill>>24);
file_bin_write_byte(file, skill>>16);
file_bin_write_byte(file, skill>>8);
file_bin_write_byte(file, skill);
file_bin_write_byte(file, weapon);
file_bin_write_byte(file, item);

file_bin_close(file);
return 1;