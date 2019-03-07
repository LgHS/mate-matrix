// https://www.shadertoy.com/view/ldX3zr
#define PROCESSING_COLOR_SHADER

vec2 center = vec2(0.5,0.5);
float speed = 0.035;

uniform float time;
uniform float occupation;
uniform vec2 resolution;
uniform sampler2D cam;

void main() {
    float invAr = resolution.y / resolution.x;

    vec2 uv = gl_FragCoord.xy / resolution.xy;
    vec4 t = texture2D(cam, vec2(uv.x, 1.0-uv.y));
		
	vec3 col = vec4(uv,0.5+0.5*sin(time),1.0).xyz;
   
    vec3 texcol;
			
	float x = (center.x-uv.x);
	float y = (center.y-uv.y) *invAr;
		
	//float r = -sqrt(x*x + y*y); //uncoment this line to symmetric ripples
	float r = -(x*x + y*y);
	float z = 1.0 + 0.5*sin((r+time*speed)/0.013);
	
	texcol.x = z;
	texcol.y = z;
	texcol.z = z;

    col.rgb *= t.rgb;
	
	gl_FragColor = vec4(col*texcol,0.3);
}
