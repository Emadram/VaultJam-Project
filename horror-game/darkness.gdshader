shader_type canvas_item;

// Player position in world coordinates
uniform vec2 player_position = vec2(960.0, 540.0);
// Light radius
uniform float light_radius = 200.0;
// Darkness color (Abyssal Blue #090A14)
uniform vec4 darkness_color : source_color = vec4(0.035, 0.039, 0.078, 0.95);

void fragment() {
	// Get current pixel position in world coordinates
	vec2 pixel_world_pos = FRAGCOORD.xy;
	
	// Calculate distance from player position
	float dist = distance(pixel_world_pos, player_position);
	
	// Smooth gradient from light to dark
	float alpha = smoothstep(light_radius * 0.5, light_radius, dist);
	
	// Apply darkness
	COLOR = vec4(darkness_color.rgb, darkness_color.a * alpha);
}
