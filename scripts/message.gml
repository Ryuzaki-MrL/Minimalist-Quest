/// message(textarray [text1], ...)

with(obj_textbox) instance_destroy();

var text = instance_create(0,0,obj_textbox);

if (is_array(argument[0])) {
    text.tn = array_length_1d(argument[0]);
    text.origstr = argument[0];
} else {
    text.tn = argument_count;
    for (var i = 0; i < argument_count; i++) {
        text.origstr[i] = argument[i];
    }
} return text;
