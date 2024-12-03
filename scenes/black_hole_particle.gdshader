shader_type particles;

uniform float range_start;
uniform float range_end;
uniform float angle_per_frame;
uniform float black_hole_radius;
uniform float fall_speed;
uniform sampler2D scale_curve:  repeat_disable;
uniform sampler2D speed_curve : hint_default_white;

uint hash( uint x ) {
    x += ( x << 10u );
    x ^= ( x >>  6u );
    x += ( x <<  3u );
    x ^= ( x >> 11u );
    x += ( x << 15u );
    return x;
}

uint hash2( uvec3 v ) { return hash( v.x ^ hash(v.y) ^ hash(v.z)             ); }

float floatConstruct( uint m ) {
    const uint ieeeMantissa = 0x007FFFFFu; // binary32 mantissa bitmask
    const uint ieeeOne      = 0x3F800000u; // 1.0 in IEEE binary32

    m &= ieeeMantissa;                     // Keep only mantissa bits (fractional part)
    m |= ieeeOne;                          // Add fractional part to 1.0

    float  f = uintBitsToFloat( m );       // Range [1:2]
    return f - 1.0;                        // Range [0:1]
}

float random( uvec3  v ) { return floatConstruct(hash2((v))); }



// number, range_start, range_end
float range(vec3 v){return v.x * (v.z - v.y) + v.y;}









void start() {
	// Called when a particle is spawned.
	//VELOCITY = vec3(1,0,0) ;

}



mat4 rotate_matrix_z(float radian){

	return  mat4(mat3(vec3(cos(radian),sin(radian),0), vec3(-sin(radian),cos(radian),0), vec3(0,0,1)));
}


void process() {
	 //Called every frame on existing particles (according to the Fixed FPS property).


	float random_number1 = random(uvec3(RANDOM_SEED,floatBitsToUint(TIME),NUMBER));
	float random_number2 = random(uvec3(RANDOM_SEED,NUMBER,floatBitsToUint(random_number1)));
	float random_number3 = random(uvec3(NUMBER,floatBitsToUint(random_number2),RANDOM_SEED));

	bool respawn = false;

	if (RESTART){

		respawn = true;
	}

	float scale = USERDATA1.x;



float modifier = 0.0;


	//if (scale < 1.0){
//
		//scale = clamp(scale + DELTA * 0.001,0,1);
	//}


	if(USERDATA1.z <= 0.0 ) {
		modifier = -fall_speed * clamp(1.0 - USERDATA1.y,0.1,1);
		}
else{
	USERDATA1.z -= 1.0;

}


float radian = radians((angle_per_frame + texture(speed_curve,vec2(USERDATA1.y,0))).x * DELTA) ;

	mat3 basis_change = mat3(vec3(cos(radian)+ modifier,sin(radian),0.0), vec3(-sin(radian),cos(radian)+ modifier,0.0), vec3(0,0,1.0));



	mat4 rotation = mat4(basis_change);// + mat4(vec4(0),vec4(0),vec4(0),vec4(vec3(0,0,0),0));



	float distance_from_singularity = length(TRANSFORM[3].xyz);


	//if (distance_from_singularity < black_hole_radius){
	//respawn = true;
	//}

	//COLOR.x = LIFETIME/ 10.0;
	//TRANSFORM = mat4(vec4(1,0,0,0), vec4(0,1,0,0), vec4(0,0,1,0), vec4(distance_from_singularity,0,0,1) );
	TRANSFORM = rotation * TRANSFORM;//(TRANSFORM - mat4(vec4(0), vec4(0), vec4(0), vec4(-1,0,0,0) ));
	//TRANSFORM =  scale_matrix * TRANSFORM ;

	float persentage_distance = ((distance_from_singularity)/ range_end);

	scale = texture(scale_curve, vec2(persentage_distance,0)).x;



	TRANSFORM[0].xyz = normalize(TRANSFORM[0].xyz);
	TRANSFORM[1].xyz = normalize(TRANSFORM[1].xyz);
	TRANSFORM[2].xyz = normalize(TRANSFORM[2].xyz);
	TRANSFORM[0].xyz *= sign(scale) * max(abs(scale), 0.001);
	TRANSFORM[1].xyz *= sign(scale) * max(abs(scale), 0.001);
	TRANSFORM[2].xyz *= sign(scale) * max(abs(scale), 0.001);


	if (respawn == true){


		VELOCITY = vec3(0,0,0);

		float distance_var = range(vec3(random_number3,range_start,range_end));
		float rotation = range(vec3(random_number1,0,TAU));

		TRANSFORM = mat4( vec4(1,0,0,1), vec4(0,1,0,1), vec4(0,0,1,1), vec4(distance_var,0,0,1) );
		TRANSFORM = rotate_matrix_z(rotation) * TRANSFORM;

		USERDATA1.x = 0.0;
		USERDATA1.y = distance_var;
		USERDATA1.z = 10.0;
		//VELOCITY += vec3(0,0,1);

	}




	//COLOR.xyz = vec3((1.0 - persentage_distance)*55.0,0,0);



	USERDATA1.x = scale;
	USERDATA1.y = persentage_distance;




}
