shader_type spatial;
render_mode shadows_disabled;
//, cull_disabled


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

float random( vec3  v ) { return floatConstruct(hash2(floatBitsToUint(v))); }


const float light_energy = 1.0;
const float cone_angle = radians(10.0 *2.0);
const vec3 cone_start_psition = vec3(0,500,0);
const float cone_hieght_offset = float(-500);

varying mat4 modelview_matrix;
varying vec3 camera_position;
varying vec3 local_normals;
varying vec3 position;
//varying float distance_to_cone_origin;



void vertex() {
	// Called for every vertex the material is visible on.


	position = vec3(VERTEX.x, VERTEX.y, VERTEX.z) + cone_start_psition;
	local_normals = NORMAL;
	//distance_to_cone_origin = (length(position));
	modelview_matrix = MODELVIEW_MATRIX;

}
// normalize  recomended
float angle_to(vec3 vector1,vec3 vector2){
return atan(length(cross(vector1,vector2)), dot(vector1,vector2));

}



void fragment() {
	// Called for every pixel the material is visible on.
	float random_number = random(vec3( FRAGCOORD.xy, TIME ));

	float distance_to_cone_origin = (length(position));

	//vec3 direction_from_camera = self.basis.y
	vec3 local_direction_from_camera = vec3( (vec4(VIEW, 1) * (modelview_matrix)).xyz);

	vec3 cone_angle_vector = -(normalize(position));

	float angle = abs(angle_to(local_direction_from_camera, cone_angle_vector));
	float end_angle = PI - cone_angle - angle ;

	float distance_in_cone = abs(sin(cone_angle) * (distance_to_cone_origin / sin(end_angle)));

	vec2 forward_direction = (normalize(vec2(local_direction_from_camera.x,local_direction_from_camera.z)));
	vec2 direction_to_middle = (normalize(vec2(position.x,position.z)));
	float scalar = (dot(vec3(forward_direction.x,0,forward_direction.y), vec3(direction_to_middle.x,0,direction_to_middle.y)));

	distance_in_cone = distance_in_cone * scalar;

	distance_in_cone = (distance_in_cone);

	ALPHA = clamp(float(distance_in_cone/100.0  * inversesqrt(distance_to_cone_origin)),0.0,1.0);// * scalar;
	//ALPHA = ALPHA + light_energy * (inversesqrt(distance_to_cone_origin));
	//ALBEDO = vec4(vec4(VIEW, 0) * inverse(modelview_matrix)).xyz;

	EMISSION = COLOR.xyz * vec3(0.5,2,0.5);



}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
