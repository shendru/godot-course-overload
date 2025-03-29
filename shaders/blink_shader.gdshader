shader_type canvas_item;

uniform float flash_amount;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // White by default

void fragment() {
    vec4 base_color = texture(TEXTURE, UV);
    base_color = mix(base_color, flash_color, flash_amount * base_color.a);
    COLOR = base_color;
}