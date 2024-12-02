shader_type spatial;
render_mode particle_trails,world_vertex_coords,ambient_light_disabled,shadows_disabled;

uniform sampler2D normal_texture: hint_normal;
uniform sampler2D noise_texture: hint_default_black;

uniform vec3 color: source_color;
uniform vec3 color_iner: source_color;
uniform vec3 color_outer: source_color;

varying float percent_distance;

void vertex() {
	// Called for every vertex the material is visible on.
	percent_distance = length(vec2(VERTEX.xy))/500.0;
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = color *1.0;
	ALBEDO += (color_iner *10.0) * (1.0 - percent_distance);
	ALBEDO += (color_outer *10.0) * (percent_distance);
	//ALPHA = 0.1;
	//ALPHA_HASH_SCALE = 1.0;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
