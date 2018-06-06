#ifdef GL_ES
precision mediump float;
precision mediump int
#endif

#define PROCESSING_LIGHT_SHADER
#define PROCESSING_COLOR_SHADER
uniform float fraction;
uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_avgFreq;
uniform float u_time;


varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;

float plot(vec2 st, float pct){
	return smoothstep(pct-0.02, pct,st.y)-smoothstep(pct,pct+0.02, st.y);
}

void main()
{
	float intensity;
	vec4 color;
	vec2 st =gl_FragCoord.st/u_resolution;

	intensity = max(0.0, dot(vertLightDir, vertNormal));
	if(intensity > pow(0.95, fraction)){
		color = vec4(vec3(0.3), 1.0); //(vec4(cos(st.x*u_direction.x*100.0),st.y, sin(st.y*u_direction.y*200.0),1.0)*vec4(vertNormal,0.0));
	}else if (intensity > pow(0.5, fraction)){
		color = vec4(vec3(0.6),1.0);
	}else if (intensity > pow(0.25, fraction)){
		color = vec4(vec3(0.4), 1.0);
	}else{
		color = vec4(vec3(0.2),1.0);
	}
	float y = sin(u_avgFreq)+cos(st.x);
	float pct = plot(st, y);
	//gl_FragColor = (1.0-pct)*color+pct*vec4(1.0,0.0,0.0,1.0);
	//gl_FragColor =color.rgba/vec4(st.x,st.y,0.3,0.5);
	gl_FragColor = vec4(
												//color.r*ceil(abs(sin(st.x*10.0-cos(st.y+u_avgFreq*100.0)))*1.5),
												color.r,
												cos(st.y+u_time/1000.0)*color.g,
												sin(st.x+u_time/100.0)*abs(cos(color.b+st.x)),
												color.a*0.3
												)*1.7;
	//gl_FragColor = vec4(sin(st.x), vec3(0.5));
}
