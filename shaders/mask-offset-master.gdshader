shader_type canvas_item;

uniform sampler2D mask_texture : source_color;
uniform float offset : hint_range(0.0, 1.0);
uniform bool inverse;

void fragment() {
    vec4 main_texture_color = texture(TEXTURE, UV); // Get the sprite's texture color
    vec4 mask_color = texture(mask_texture, UV);    // Get the mask color
    float mask_value = mask_color.r;               // Use red channel from mask

    bool should_show = mask_value > offset;

    if (inverse) {
        should_show = !should_show;
    }

    if (should_show) {
        // Multiply the texture color by the incoming COLOR (which has modulate applied)
        COLOR = main_texture_color * COLOR;
    } else {
        // Keep transparent parts transparent
        COLOR = vec4(0.0, 0.0, 0.0, 0.0);
        // Or alternatively, to respect modulate's alpha on the hidden parts:
        // COLOR.a = 0.0; // Just force alpha to 0, keeps modulated color if needed elsewhere
    }
}