shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

float rand(vec2 seed) {
	vec2 K1 = vec2( 23.14069263277926, 2.665144142690225 );
	return fract(cos(dot(seed, K1)) * 12345.6789);
}

void fragment() {
	float val = rand(FRAGCOORD.xy * vec2(fract(TIME), fract(TIME)));
	COLOR = vec4(val, val, val, 1.0) * COLOR;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}