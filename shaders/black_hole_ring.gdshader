shader_type spatial;
render_mode particle_trails,world_vertex_coords,ambient_light_disabled,shadows_disabled;




uniform sampler2D curve: repeat_disable;

uniform sampler2D curve_emission: repeat_disable;
uniform float emission_multilpier;
varying float percent_distance;

void vertex() {
	// Called for every vertex the material is visible on.
	percent_distance = length(vec2(VERTEX.xy))/500.0;
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = vec3(1,1,1);
	ALBEDO *=  texture(curve,vec2(percent_distance)).rgb;
	//(ALBEDO += (color_outer) * texture(curve_outer,vec2(percent_distance)).x;
	ALPHA = 0.1;
	EMISSION = ALBEDO * (emission_multilpier * texture(curve_emission, vec2(percent_distance)).r);
	ROUGHNESS = 1.0;


}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
