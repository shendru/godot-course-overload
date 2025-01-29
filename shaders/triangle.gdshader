shader_type canvas_item;

uniform float damage_effect : hint_range(0.0, 1.0);

void fragment() {
    vec2 uv = UV * 2.0 - 1.0; // Remap UV coordinates to -1 to 1
    uv.y += 1.0; // Shift the triangle up

    // Define the triangle edges for an upward-pointing triangle
    float edge0 = uv.y - sqrt(4.0) * uv.x; // Left edge
    float edge1 = uv.y + sqrt(4.0) * uv.x; // Right edge
    float edge2 = -uv.y - 1.0;           // Bottom edge

    if (edge0 > 0.0 && edge1 > 0.0 && edge2 < 0.0) {
        vec3 base_color = vec3(1.0, 0.0, 0.0); // Default red triangle

        // White at damage_effect = 1.0, Black at damage_effect = 0.5
        vec3 flash_color = vec3(1.0) * step(0.75, damage_effect) +
                           vec3(0.0) * step(0.25, damage_effect) * step(damage_effect, 0.75);

        vec3 final_color = mix(base_color, flash_color, damage_effect);
        COLOR = vec4(final_color, 1.0);
    } else {
        discard;
    }
}
