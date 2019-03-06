#define PROCESSING_COLOR_SHADER

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform float freq0;


void main( void ) {

	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv = uv * 2. -1.;
	float val = freq0 * 905.;
    // Time varying pixel color
    //vec3 col = 0.5 + 0.5*cos(time+uv.xyx+vec3(0,2,4));
     vec3 col = vec3(0.);
		col.rgb = vec3(abs(sin(freq0)),uv.y*sin(val),cos(val))*vec3(sin(val),cos(uv.xy*freq0));
    col *= smoothstep(abs(sin(uv.y*uv.y)*acos(uv.x*uv.x))*val*val, sin(uv.x*mod(freq0+250.,500.))*.3, 3.)
		+ smoothstep(0.1, .9, freq0*.03);
		col *= smoothstep(0.2,1.7, freq0 );
	gl_FragColor = vec4(col, 1.0 );

}
