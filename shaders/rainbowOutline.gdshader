shader_type canvas_item;

uniform float line_thickness : hint_range(0, 20) = 1.0; // Increased hint range
uniform float sin_frequency : hint_range(0.1, 2.0) = 0.5;
uniform float sin_offset : hint_range(0.0, 360.0) = 0.0;
uniform float light_offset : hint_range(0.0, 1.0) = 0.5;

const vec2 OFFSETS[24] = { // Increased offset array
    vec2(-1, -1), vec2(-1, 0), vec2(-1, 1), vec2(0, -1), vec2(0, 1),
    vec2(1, -1), vec2(1, 0), vec2(1, 1),
    vec2(-2, -2), vec2(-2, -1), vec2(-2, 0), vec2(-2, 1), vec2(-2, 2),
    vec2(-1, -2), vec2(0, -2), vec2(1, -2), vec2(2, -2),
    vec2(2, -1), vec2(2, 0), vec2(2, 1), vec2(2, 2),
    vec2(-1, 2), vec2(0, 2), vec2(1, 2)
};

void fragment() {
    vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
    float outline = 1.0;

    for (int i = 0; i < OFFSETS.length(); i++) {
        outline *= texture(TEXTURE, UV + size * OFFSETS[i]).a;
    }
    outline = 1.0 - outline;

    vec4 animated_line_color = vec4(
        light_offset + sin(2.0 * 3.14 * sin_frequency * TIME + radians(sin_offset)),
        light_offset + sin(2.0 * 3.14 * sin_frequency * TIME + radians(120.0 + sin_offset)),
        light_offset + sin(2.0 * 3.14 * sin_frequency * TIME + radians(240.0 + sin_offset)),
        1.0
    );

    vec4 color = texture(TEXTURE, UV);
    COLOR = mix(color, animated_line_color, outline * color.a);
}