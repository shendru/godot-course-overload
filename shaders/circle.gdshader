shader_type canvas_item;

void fragment() {
    vec2 uv = UV * 2.0 - 1.0; // Remap UV coordinates to -1 to 1

    // Calculate the distance from the center
    float distance = length(uv);

    // If the distance is less than or equal to 1 (the radius), it's inside the circle
    if (distance <= 0.9) {
        // Use the original texture color (if available)
        COLOR = texture(TEXTURE, UV);
        //OR for a solid color circle
        //COLOR = vec4(1.0, 0.0, 0.0, 1.0); // Red circle

    } else {
        discard; // Discard pixels outside the circle
    }
}