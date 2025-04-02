shader_type canvas_item;

uniform float hue_shift : hint_range(0.0, 1.0) = 0.0; // Hue shift from 0 to 1
uniform float saturation_boost : hint_range(0.0, 2.0) = 1.0; // Saturation multiplier
uniform vec4 overlay_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // Default red overlay
uniform float overlay_intensity : hint_range(0.0, 1.0) = 0.0; // Overlay strength
uniform float flash_amount : hint_range(0.0, 1.0) = 0.0; // Flash intensity
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Flash color

uniform bool enable_rainbow_outline = false; // Toggle for rainbow outline
uniform float line_thickness : hint_range(0, 20) = 1.0;
uniform float sin_frequency : hint_range(0.1, 2.0) = 0.5;
uniform float sin_offset : hint_range(0.0, 360.0) = 0.0;
uniform float light_offset : hint_range(0.0, 1.0) = 0.5;

const vec2 OFFSETS[24] = {
    vec2(-1, -1), vec2(-1, 0), vec2(-1, 1), vec2(0, -1), vec2(0, 1),
    vec2(1, -1), vec2(1, 0), vec2(1, 1), vec2(-2, -2), vec2(-2, -1),
    vec2(-2, 0), vec2(-2, 1), vec2(-2, 2), vec2(-1, -2), vec2(0, -2),
    vec2(1, -2), vec2(2, -2), vec2(2, -1), vec2(2, 0), vec2(2, 1),
    vec2(2, 2), vec2(-1, 2), vec2(0, 2), vec2(1, 2)
};

// RGB to HSV conversion
vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

// HSV to RGB conversion
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
    vec4 base_color = texture(TEXTURE, UV);
    float luminance = dot(base_color.rgb, vec3(0.299, 0.587, 0.114));

    // Apply overlay only if the color is not dark (preserves black outlines)
    vec3 tinted_color = mix(base_color.rgb, overlay_color.rgb, overlay_intensity * step(0.2, luminance));

    // Convert to HSV for hue shift
    vec3 hsv = rgb2hsv(tinted_color);
    hsv.x = mod(hsv.x + hue_shift, 1.0);
    hsv.y = clamp(hsv.y * saturation_boost, 0.0, 1.0);
    vec3 shifted_rgb = hsv2rgb(hsv);

    // Apply flash effect
    vec3 final_color = mix(shifted_rgb, flash_color.rgb, flash_amount);

    // Rainbow outline logic
    float outline = 1.0;
    vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;

    for (int i = 0; i < OFFSETS.length(); i++) {
        outline *= texture(TEXTURE, UV + size * OFFSETS[i]).a;
    }
    outline = 1.0 - outline;

    // Animated rainbow color
    vec4 rainbow_color = vec4(
        light_offset + sin(2.0 * 3.14 * sin_frequency * TIME + radians(sin_offset)),
        light_offset + sin(2.0 * 3.14 * sin_frequency * TIME + radians(120.0 + sin_offset)),
        light_offset + sin(2.0 * 3.14 * sin_frequency * TIME + radians(240.0 + sin_offset)),
        1.0
    );

    // Mix rainbow outline only if enabled
    if (enable_rainbow_outline) {
        final_color = mix(final_color, rainbow_color.rgb, outline * base_color.a);
    }

    COLOR = vec4(final_color, base_color.a);
}
