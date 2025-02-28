shader_type canvas_item;

uniform float wave_speed = 2.0;
uniform float wave_strength = 0.05;
uniform float wave_frequency = 8.0;
uniform float circle_radius = 0.75; // Adjust to control circle size

void fragment() {
    vec2 uv = UV * 2.0 - 1.0; // Normalize UV to [-1, 1]

    float distance = length(uv) / circle_radius; // Scale the circle size

    // Wavy distortion
    float wave = sin(uv.x * wave_frequency + TIME * wave_speed) * wave_strength;
    wave += cos(uv.y * wave_frequency + TIME * wave_speed) * wave_strength;

    distance += wave;

    // Circle mask with distortion
    float circle = smoothstep(1.0, 0.98, distance);

    // Use the sprite's existing texture color and multiply by self_modulate
    vec4 tex_color = texture(TEXTURE, UV) * COLOR;
    COLOR = tex_color * circle;
}
