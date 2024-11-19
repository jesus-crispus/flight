shader_type spatial;
render_mode world_vertex_coords;
uniform vec3 color: source_color;
uniform sampler2D normal_texture: hint_normal;
uniform sampler2D noise_texture: hint_default_black;

varying vec2 global_position;

void vertex() {
	// Called for every vertex the material is visible on.
	
	global_position = VERTEX.xy;
	global_position *= 0.01;
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	
	NORMAL = VIEW * texture(normal_texture,global_position).rgb;
	ALBEDO = texture(noise_texture,global_position).rgb;
	ALBEDO = NORMAL;
	
	ROUGHNESS = 0.54;
	
	
	
	
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
