shader_type canvas_item;

uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // White by default

void fragment() {
    vec4 base_color = texture(TEXTURE, UV);
    vec3 final_color = mix(base_color.rgb, flash_color.rgb, flash_amount);
    COLOR = vec4(final_color, base_color.a); // Keep original alpha
}