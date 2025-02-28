shader_type canvas_item;

uniform float sway_amount : hint_range(0.0, 0.1) = 0.01; // Adjust sway intensity
uniform float sway_speed : hint_range(0.0, 5.0) = 1.0; // Adjust sway speed
uniform float time_scale : hint_range(0.0, 10.0) = 1.0;

void vertex() {
    float sway = sin(TIME * sway_speed * time_scale + VERTEX.x * 0.1) * sway_amount; // Calculate sway offset
    VERTEX.x += sway; // Apply sway offset to vertex position
}