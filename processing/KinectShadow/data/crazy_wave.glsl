// https://www.shadertoy.com/view/XtsXRX
#define PROCESSING_COLOR_SHADER

uniform float time;
uniform float occupation;
uniform vec2 resolution;
uniform sampler2D cam;

void main() {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
    vec4 t = texture2D(cam, vec2(uv.x, 1.0-uv.y));

	vec3 wave_color = vec3(0.0);
	float timeFactor = time * occupation;

	float wave_width = 0.0;
	uv  = -3.0 + 2.0 * uv;
	uv.y += 0.0;
	for(float i = 0.0; i <= 28.0; i++) {
		uv.y += (0.2+(0.9*sin(timeFactor*0.4) * sin(uv.x + i/3.0 + 3.0 *timeFactor )));
        uv.x += 1.7* sin(timeFactor*0.4);
		wave_width = abs(1.0 / (200.0*abs(cos(timeFactor)) * uv.y));
		wave_color += vec3(wave_width *( 0.4+((i+1.0)/18.0)), wave_width * (i / 9.0), wave_width * ((i+1.0)/ 8.0) * 1.9);
	}

    wave_color.rgb *= t.rgb;

	gl_FragColor = vec4(wave_color, 0.2);
}