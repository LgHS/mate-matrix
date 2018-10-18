#define PROCESSING_COLOR_SHADER

uniform float time;
uniform float occupation;
uniform vec2 resolution;
uniform float freq0;
uniform sampler2D cam;
uniform bool idle;
varying vec4 vertColor;

// absolutely not what we wanted to do, but wow
void main() {
    vec2 uv = gl_FragCoord.xy / resolution.xy ;
    vec4 t = texture2D(cam, vec2(uv.x, 1.0-uv.y));

    vec3 col = 0.5 + 0.5 * cos(time+uv.xyx*vec3(0, 2,4));
    col +=  vec3(sin(occupation*10), 0, 0);
    
    col.rgb *= t.rgb;

    gl_FragColor = vec4(col, step(0.2, col) * 0.05);
}
