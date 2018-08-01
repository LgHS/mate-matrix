#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 resolution;



void main( void ) {

	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv.y -= .5;
	uv.y *= resolution.y/resolution.x;
	vec3 c = vec3(0.);

	c+=smoothstep(uv.y, uv.x+uv.y+sin(time*cos(time)*2.), .02);
	c*=vec3(sin(uv), .3);

	gl_FragColor = vec4(vec3(c), 1.0 );

}
