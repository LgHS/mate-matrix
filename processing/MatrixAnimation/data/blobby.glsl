#define PROCESSING_COLOR_SHADER

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform float occupation;
uniform vec2 resolution;
uniform float rate;

#define N 16

void main( void ) {
	vec2 v=(gl_FragCoord.xy-(resolution*0.5))/min(resolution.y,resolution.x)*10.0;
	float t=time * 0.3,r=2.0;
	for (int i=1;i<N;i++){
		float d=(3.14159265 / float(N))*(float(i)*14.0);
		r+=length(vec2(occupation*v.y,occupation*v.x))+1.21;
		v = vec2(v.x+cos(v.y+cos(r)+d)+cos(t),v.y-sin(v.x+cos(r)+d)+sin(t));
	}
        r = (sin(r*0.09)*0.5)+0.5;
	r = pow(r, occupation);
	gl_FragColor = vec4(r,pow(max(r-0.55,0.0)*42,2.0),pow(max(r-4.875,0.1)*3.0,6.0), 1.0 );
}
