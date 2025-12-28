shader_type canvas_item;

// Player position in screen coordinates
uniform vec2 player_position = vec2(960.0, 540.0);
// Base Light radius around player
uniform float light_radius = 200.0;
// Complete darkness - pitch black with slight transparency
uniform vec4 darkness_color : source_color = vec4(0.0, 0.0, 0.0, 0.85);

// Fire light positions (up to 5 fires)
uniform vec2 fire_positions[5];
uniform int fire_count = 0;
uniform float fire_light_radius = 450.0;

// Simple pseudo-random noise for flicker
float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	// Get current pixel position in screen coordinates
	vec2 pixel_pos = FRAGCOORD.xy;
	
	// Calculate player light influence
	float player_dist = distance(pixel_pos, player_position);
	
	// Organic flicker for player light
	float breathe = sin(TIME * 2.0) * 0.1 + sin(TIME * 5.13) * 0.05;
	float jitter = random(vec2(TIME, 0.0)) * 0.05;
	float current_player_radius = light_radius * (0.95 + breathe + jitter);
	
	// Soft edge for player light
	float soft_edge = current_player_radius * (0.2 + breathe * 0.5); 
	float player_alpha = smoothstep(current_player_radius - soft_edge, current_player_radius, player_dist);
	
	// Calculate fire light influence
	float fire_alpha = 1.0;
	for (int i = 0; i < fire_count && i < 5; i++) {
		float fire_dist = distance(pixel_pos, fire_positions[i]);
		
		// Each fire has its own organic flicker
		float fire_breathe = sin(TIME * 1.5 + float(i) * 2.0) * 0.15;
		float fire_jitter = random(vec2(TIME + float(i), float(i))) * 0.1;
		float current_fire_radius = fire_light_radius * (0.9 + fire_breathe + fire_jitter);
		
		// Fires have larger, softer falloff
		float fire_soft = current_fire_radius * 0.4;
		float this_fire_alpha = smoothstep(current_fire_radius - fire_soft, current_fire_radius, fire_dist);
		
		// Multiply alpha (brighter if multiple fires overlap)
		fire_alpha *= this_fire_alpha;
	}
	
	// Combine player light and fire lights (take minimum darkness)
	float final_alpha = min(player_alpha, fire_alpha);
	
	// Apply pitch-black darkness
	COLOR = vec4(darkness_color.rgb, darkness_color.a * final_alpha);
}
