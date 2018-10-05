#define PROCESSING_COLOR_SHADER

uniform float time;
uniform float occupation;
uniform vec2 res;
uniform float freq0;
uniform sampler2D cam;
uniform bool idle;
varying vec4 vertColor;

void main() {
    vec2 uv = gl_FragCoord.xy / res.xy ;
    vec4 t = texture2D(cam, vec2(uv.x, 1.0-uv.y));

    vec3 col = 0.5 + 0.5 * cos(time+uv.xxy*vec3(0, 2,4));
    col +=  vec3(sin(occupation*10), 0, 0);
    
    if (!idle) {
        col.rgb *= t.rgb;
    }

    gl_FragColor = vec4(col, 0.15);
}
