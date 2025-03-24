shader_type canvas_item;


uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

uniform float wave_progress : hint_range(0.0, 5.0) = 0.0; // Controlled by AnimationPlayer
uniform float wave_speed = 1.0;
uniform vec3 wave_params = vec3(10.0, 0.8, 0.1); // (Frequency, Intensity, Thickness)
uniform vec2 wave_center = vec2(0.5, 0.5); // Normalized center of ripple

void fragment() {
    vec2 resolution = vec2(textureSize(SCREEN_TEXTURE, 0));
    float ratio = resolution.x / resolution.y; // Aspect ratio correction
    vec2 uv = SCREEN_UV;

    // Normalize coordinates
    vec2 center = wave_center;
    vec2 dir = uv - center;

    // Apply aspect ratio correction **only to direction vector**
    dir.x *= ratio;

    float dist = length(dir);

    // Get original screen color
    vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);

    // Apply ripple only within the donut-shaped range
    if ((dist <= (wave_progress + wave_params.z)) && (dist >= (wave_progress - wave_params.z))) {
        float diff = (dist - wave_progress);
        float scale_diff = 1.0 - pow(abs(diff * wave_params.x), wave_params.y);
        float diff_time = diff * scale_diff;

        // Normalize direction vector **after correction**
        vec2 diff_tex_coord = normalize(dir);
        diff_tex_coord.x /= ratio; // Undo aspect correction after normalization

        // Apply distortion ONLY inside the ripple
        uv += ((diff_tex_coord * diff_time) / (wave_progress * dist * 40.0));

        // Blend new color with original screen color
        color = texture(SCREEN_TEXTURE, uv);

        // Enhance ripple effect by amplifying the color
        color += (color * scale_diff) / (wave_progress * dist * 40.0);
    }

    // Output final color
    COLOR = color;
}