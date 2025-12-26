shader_type canvas_item;

// Player position in screen coordinates
uniform vec2 player_position = vec2(0.5, 0.5);
// Light radius
uniform float light_radius = 200.0;
// Darkness color (not pure black)
uniform vec4 darkness_color : source_color = vec4(0.05, 0.05, 0.1, 0.9);

void fragment() {
	// Get distance from player position
	vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 pixel_pos = FRAGCOORD.xy;
	vec2 player_pixel_pos = player_position * screen_size;
	
	float dist = distance(pixel_pos, player_pixel_pos);
	
	// Smooth gradient from light to dark
	float alpha = smoothstep(light_radius * 0.5, light_radius, dist);
	
	// Apply darkness
	COLOR = vec4(darkness_color.rgb, darkness_color.a * alpha);
}
