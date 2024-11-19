shader_type spatial;
render_mode cull_disabled,particle_trails;

uniform sampler2D normal_texture: hint_normal;
uniform sampler2D noise_texture: hint_default_black;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
