#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 res;

void main() {
    vec2 uv = gl_FragCoord.xy / res.xy ;

    vec3 col = 0.5 + 0.5 * cos(time+uv.xyx*vec3(0, 2, 4));

    gl_FragColor = vec4(col, 1);
}
