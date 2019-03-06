#define PROCESSING_COLOR_SHADER

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 colorMult;
uniform float coeffx;
uniform float coeffy;
uniform float coeffz;


void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

	float color = 0.0;
	float _time = time;
	color += sin( position.x * cos( _time / 15.0 ) * 10.0 )  +  cos( position.y * cos( _time / 15.0 ) * coeffx );
	color += sin( position.y * sin( _time / 10.0 ) * coeffz )  +  cos( position.x * sin( _time / 25.0 ) * coeffy );
	color += sin( position.x * sin( _time / 50.0 ) * coeffx )  +  sin( position.y * sin( _time / 35.0 ) * coeffz );

	color *= sin( time / 10.0 ) * 0.5;

	float r = color;
	float g = color * colorMult.y;
	float b = sin( color + _time / 2.0 ) * colorMult.x;

	gl_FragColor = vec4(r, g, b, 1.0 );

}
