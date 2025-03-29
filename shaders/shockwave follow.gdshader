shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec2 sprite_screen_pos; // World position of sprite in screen-space
uniform float wave_progress : hint_range(0.0, 5.0) = 0.0;
uniform float wave_speed = 1.0;
uniform vec3 wave_params = vec3(10.0, 0.8, 0.1); // (Frequency, Intensity, Thickness)

void fragment() {
    vec2 resolution = vec2(textureSize(SCREEN_TEXTURE, 0));
    float ratio = resolution.x / resolution.y;
    vec2 uv = SCREEN_UV;

    // Convert sprite position from pixels to normalized UV space
    vec2 wave_center = sprite_screen_pos / resolution;

    // Compute direction and apply aspect correction
    vec2 dir = uv - wave_center;
    dir.x *= ratio;

    float dist = length(dir);

    // Get original screen color
    vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);

    // Apply ripple effect only inside the wave range
    if ((dist <= (wave_progress + wave_params.z)) && (dist >= (wave_progress - wave_params.z))) {
        float diff = (dist - wave_progress);
        float scale_diff = 1.0 - pow(abs(diff * wave_params.x), wave_params.y);
        float diff_time = diff * scale_diff;

        // Normalize direction vector
        vec2 diff_tex_coord = normalize(dir);
        if (length(dir) > 0.001) {
    		diff_tex_coord = normalize(dir);
		}

        // Apply distortion ONLY inside the ripple
        float safe_wave_progress = max(wave_progress, 0.01); // Prevent division by zero
		uv += ((diff_tex_coord * diff_time) / (safe_wave_progress * dist * 40.0));

        // Blend new color with original screen color
        color = texture(SCREEN_TEXTURE, uv);
        color += (color * scale_diff) / (wave_progress * dist * 40.0);
    }

    COLOR = color;
}
