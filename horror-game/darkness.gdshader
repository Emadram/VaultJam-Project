shader_type canvas_item;

// Player position in world coordinates
uniform vec2 player_position = vec2(960.0, 540.0);
// Base Light radius
uniform float light_radius = 200.0;
// Darkness color (Abyssal Blue #090A14)
uniform vec4 darkness_color : source_color = vec4(0.035, 0.039, 0.078, 0.95);

// Simple pseudo-random noise
float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	// Get current pixel position in world coordinates
	vec2 pixel_world_pos = FRAGCOORD.xy;
	
	// Calculate distance from player position
	float dist = distance(pixel_world_pos, player_position);
	
	// Organic Flicker Calculation
	// Combine two sine waves for a non-repetitive breathing effect
	float breathe = sin(TIME * 2.0) * 0.1 + sin(TIME * 5.13) * 0.05;
	
	// Add high-frequency jitter for "fire" feel
	float jitter = random(vec2(TIME, 0.0)) * 0.05;
	
	// Apply flicker to radius
	float current_radius = light_radius * (0.95 + breathe + jitter);
	
	// Smooth gradient from light to dark with soft edge
	// Edge softness also breathes slightly
	float soft_edge = current_radius * (0.2 + breathe * 0.5); 
	float alpha = smoothstep(current_radius - soft_edge, current_radius, dist);
	
	// Apply darkness
	COLOR = vec4(darkness_color.rgb, darkness_color.a * alpha);
}
