// https://www.shadertoy.com/view/ldBGRR
#define PROCESSING_COLOR_SHADER

uniform float time;
uniform float occupation;
uniform vec2 resolution;
uniform sampler2D cam;

void main() {
	vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    vec2 uv = gl_FragCoord.xy / resolution.xy ;
    vec4 t = texture2D(cam, vec2(uv.x, 1.0-uv.y));
	
    // main code, *original shader by: 'Plasma' by Viktor Korsun (2011)
    float x = p.x;
    float y = p.y;
    float mov0 = x+y+cos(sin(time)*2.0)*100.+sin(x/100.)*1000.;
    float mov1 = y / 0.9 +  time;
    float mov2 = x / 0.2;
    float c1 = abs(sin(mov1+time)/2.+mov2/2.-mov1-mov2+time);
    float c2 = abs(sin(c1+sin(mov0/1000.+time)+sin(y/40.+time)+sin((x+y)/100.)*3.));
    float c3 = abs(sin(c2+cos(mov1+mov2+c2)+cos(mov2)+sin(x/1000.)));
    vec3 col = vec3(c1, c2, c3);
    col.rgb *= t.rgb;
    gl_FragColor = vec4(col,0.2);
}