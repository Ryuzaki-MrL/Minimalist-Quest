#define file_bin_write_flag_array
/// file_bin_write_flag_array(file, array, count)

for (var i = 0; i < argument2; i+=8) {
    var f = 0;
    for (var j = 0; j < 8; ++j) {
        f |= (argument1[i+j] << j);
    }
    file_bin_write_byte(argument0, f);
}

#define file_bin_read_flag_array
/// file_bin_read_flag_array(file, count)

var arr;

for (i = 0; i < argument1; i+=8) {
    var f = file_bin_read_byte(argument0);
    for (var j = 0; j < 8; ++j) {
        arr[i+j] = (f >> j) & 1;
    }
}

return arr;
#define file_bin_read_word
/// file_bin_read_word(file, wordsize, bigend)

var file = argument0, size = argument1, bigend = argument2, value = 0, i, b;

for (i = 0; i < size; i++) b[i] = file_bin_read_byte(file);

if (bigend) for (i = 0; i < size; i++) value = value << 8 | b[i];
else for (i = size-1; i>=0; i--) value = value << 8 | b[i];

return value;

#define file_bin_write_word
/// file_bin_write_word(file, wordsize, bigend, value)

var file = argument0, size = argument1, bigend = argument2, value = argument3, i, b;

for (i = 0; i < size; i++) {
    b[i] = value & 255;
    value = value >> 8;
}

if (bigend) for (i = size-1; i>=0; i--) file_bin_write_byte(file,b[i]);
else for (i = 0; i < size; i++) file_bin_write_byte(file,b[i]);