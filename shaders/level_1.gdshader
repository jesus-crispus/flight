shader_type spatial;
render_mode depth_test_disabled;

uniform sampler2D curve: repeat_disable;
uniform float emission_multilpier;
varying float percent_distance;


uniform float multiplier;
uniform float x_speed;
uniform float y_speed;
uniform sampler2D normal_texture: hint_normal;
uniform sampler2D noise_texture: hint_default_black;
varying mat4 modelview_matrix;

varying float y;
varying float yy;

void vertex() {
	modelview_matrix = MODELVIEW_MATRIX;

	//UV = UV/2.0;




	//float multiplier = float(25.0);


	float bob = multiplier - sqrt(abs(VERTEX.y)* PI);// abs(distance(VERTEX, vec3(VERTEX.x,0,VERTEX.z)));

	//y = VERTEX.y/ 555.0;


	if (VERTEX.y > 0.0){
		yy = 1.0;
	}
	else{
		yy = -1.0;
	}

	 //normalize(VERTEX)
	VERTEX = VERTEX * (bob/multiplier);
	y =  VERTEX.y;
	//VERTEX.x *= abs(VERTEX.z);
	//VERTEX.y *= abs(VERTEX.z);
	percent_distance = length(vec2(VERTEX.xy))/500.0;
}

void fragment() {
	// Called for every pixel the material is visible on.
	float multiplier_local = sqrt(abs(y))*0.001;


	vec2 modified_uv = UV + (vec2((TIME * (x_speed* multiplier_local)),yy* ( y_speed) * TIME));

	ROUGHNESS = 1.0;
	//ALPHA = texture(noise_texture, modified_uv).r;


	ALBEDO = vec3(1,1,1);
	ALBEDO *=  texture(curve,vec2(percent_distance)).rgb;
	//(ALBEDO += (color_outer) * texture(curve_outer,vec2(percent_distance)).x;
	
	EMISSION = ALBEDO * emission_multilpier;
	//(ALPHA = 0.5;


	//EMISSION = ALBEDO *85.0;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
