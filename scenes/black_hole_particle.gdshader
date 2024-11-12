shader_type particles;

uniform float range_start;
uniform float range_end;
uniform float angle_per_frame;



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




//vec3 restart() {
	//float random_number1 = random(uvec3(RANDOM_SEED,floatBitsToUint(TIME),NUMBER));
	//float random_number2 = random(uvec3(RANDOM_SEED,NUMBER,floatBitsToUint(TIME)));
	//float random_number3 = random(uvec3(NUMBER,floatBitsToUint(TIME),RANDOM_SEED));
	//
	//
	//
	//float distance_var = range(vec3(random_number3,range_start,range_end));
	//
	//float range_1 = range(vec3(random_number1,-1.0,1.0));
	//float range_2 = range(vec3(random_number2,-1.0,1.0));
	//
	//vec2 star_normal2d = normalize(vec2(range_1,range_2));
	//
	//vec3 start_position = vec3(star_normal2d.x,star_normal2d.x,0) * distance_var;
	//
	//return start_position;
//}




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
	float distance_from_singularity = USERDATA1.y;
	
	if (scale < 1.0){
		
		clamp(scale + DELTA,0,1);
	}
	
	
	
	
	
		
		//
		//float range_1 = range(vec3(random_number1,1.0,1.0));
		//float range_2 = range(vec3(random_number2,1.0,1.0));
		//
		//vec2 star_normal2d = normalize(vec2(range_1,range_2));
		//
		//vec3 start_position = vec3(star_normal2d.x,star_normal2d.x,0) * distance_var;
		//
		//VELOCITY = start_position;
	
	float radian = radians(angle_per_frame);
	
	mat3 basis_change = mat3(vec3(cos(radian),sin(radian),0), vec3(-sin(radian),cos(radian),0), vec3(0,0,1));
	
	mat4 scale_matrix = mat4(vec4(1,0,0,1),vec4(0,1,0,1),vec4(0,0,1,1),vec4(vec3(0,0,0),0));
	
	
	
	mat4 rotation = mat4(basis_change) ;//+ mat4(vec4(0),vec4(0),vec4(0),vec4(vec3(0,0,0),0));
	
	
	
	//COLOR.x = LIFETIME/ 10.0;
	
	TRANSFORM = ( rotation * TRANSFORM);
	TRANSFORM =  scale_matrix * TRANSFORM ;
	
	
	
	if (respawn == true){
		
		
		VELOCITY = vec3(0,0,0);
		
		float distance_var = range(vec3(random_number3,range_start,range_end));
		float rotation = range(vec3(random_number1,0,PI));
		
		TRANSFORM = mat4( vec4(1,0,0,0), vec4(0,1,0,0), vec4(0,0,1,0), vec4(distance_var,5,0,1) );
		TRANSFORM = rotate_matrix_z(rotation) * TRANSFORM;
		
		USERDATA1.x = 0.0;
		USERDATA1.y = distance_var;
		
		//VELOCITY += vec3(0,0,1); 
		
	}
	
	
	if(LIFETIME > 9.0){
		
		
		
	}
	
	
	
	USERDATA1.x = scale;
}
