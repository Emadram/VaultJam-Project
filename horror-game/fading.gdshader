shader_type canvas_item;

// Fading shader for Level 2 objects
uniform float fade_progress : hint_range(0.0, 1.0) = 0.0;  // 0 = solid, 1 = vanished
uniform vec4 fade_color : source_color = vec4(0.5, 0.5, 0.7, 1.0);  // Blue-purple tint
uniform sampler2D noise_texture;
uniform float edge_threshold : hint_range(0.0, 1.0) = 0.3;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	
	// Alpha fade
	float alpha = 1.0 - fade_progress;
	
	// Desaturation (color → grayscale)
	float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
	vec3 desaturated = mix(tex_color.rgb, vec3(gray), fade_progress);
	
	// Color tint towards fade_color
	vec3 tinted = mix(desaturated, fade_color.rgb, fade_progress * 0.5);
	
	// Edge erosion using noise
	float noise_val = texture(noise_texture, UV + vec2(TIME * 0.05, 0.0)).r;
	float edge_fade = smoothstep(edge_threshold, edge_threshold + 0.2, noise_val + (1.0 - fade_progress));
	
	// Combine effects
	alpha *= edge_fade;
	
	COLOR = vec4(tinted, tex_color.a * alpha);
}
