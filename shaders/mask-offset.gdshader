shader_type canvas_item;

uniform sampler2D mask_texture : source_color;
uniform float offset : hint_range(0.0, 1.0);
uniform bool inverse;

void fragment() {
    vec4 mask_color = texture(mask_texture, UV);
    float mask_value = mask_color.r;

    bool should_show = mask_value > offset;

    if (inverse) {
        should_show = !should_show;
    }

    if (should_show) {
        COLOR = texture(TEXTURE, UV);
    } else {
        COLOR = vec4(0.0, 0.0, 0.0, 0.0);
    }
}