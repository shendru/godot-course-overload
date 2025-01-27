shader_type canvas_item;

void fragment() {
    vec2 uv = UV * 2.0 - 1.0; // Remap UV coordinates to -1 to 1

    // Adjust UVs for centering
    uv.y += 1.0; // Shift the triangle up

    // Define the triangle edges for an upward-pointing triangle
    float edge0 = uv.y - sqrt(4.0) * uv.x; // Left edge
    float edge1 = uv.y + sqrt(4.0) * uv.x; // Right edge
    float edge2 = -uv.y - 1.0;           // Bottom edge

    if (edge0 > 0.0 && edge1 > 0.0 && edge2 < 0.0) {
        COLOR = vec4(1.0, 0.0, 0.0, 1.0); // Red triangle
    } else {
        discard; // Discard pixels outside the triangle
    }
}