shader_type spatial;
//render_mode cull_disabled;

uniform sampler2D height_texture1: hint_default_white;
uniform sampler2D height_texture2: hint_default_white;
uniform sampler2D normal_map1: hint_default_white;
uniform sampler2D normal_map2: hint_default_white;

uniform vec3 color: source_color;
uniform vec3 top_color: source_color;
uniform vec3 bottom_color: source_color;
uniform float speed;

varying float height;






void vertex() {

	vec3 saved_normal = NORMAL;

	height = (texture(height_texture1, vec2(UV.x + TIME * speed,UV.y)).y);
	NORMAL = (texture(normal_map1, vec2(UV.x + TIME * speed,UV.y))).xyz;


	height += (texture(height_texture2, vec2(UV.x, UV.y + TIME * speed)).x);
	NORMAL += (texture(normal_map2, vec2(UV.x,UV.y + TIME * speed))).xyz;
	COLOR.rgb = color;

	NORMAL = normalize(NORMAL);

	VERTEX += + saved_normal *( height * 20.0);
	//height *= 0.5;




	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = COLOR.xyz * height;


	float top_start = 1.0;
	if(height > top_start){

		ALBEDO += (top_color * (height - top_start));
	}


	ROUGHNESS = 0.0;


	//ALBEDO = ALBEDO;





}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
