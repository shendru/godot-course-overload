shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

// Adjustable parameters
// distortion_shader.gdshader


// Uniforms (adjustable in the Inspector)
uniform float speed : hint_range(0, 5) = 1.0;
uniform float strength : hint_range(0, 0.1) = 0.02;
uniform sampler2D noise_texture; // Load a noise texture (e.g., Gaussian noise)

void fragment() {
    // Animate noise with time
    vec2 uv = UV;
    uv.x += TIME * speed * 0.1;
    uv.y += TIME * speed * 0.1;

    // Sample noise texture (red/green channels for X/Y distortion)
    vec2 noise = texture(noise_texture, uv).rg;

    // Apply distortion to the screen texture
    vec2 distorted_uv = SCREEN_UV + (noise - 0.5) * strength;
    COLOR = textureLod(SCREEN_TEXTURE, distorted_uv, 0.0);
}