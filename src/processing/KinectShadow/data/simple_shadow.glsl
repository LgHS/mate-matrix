#define PROCESSING_COLOR_SHADER

uniform float time;
uniform float occupation;
uniform vec2 resolution;
uniform sampler2D cam;

void main() {
    vec2 uv = gl_FragCoord.xy / resolution.xy ;

    vec4 t = texture2D(cam, vec2(uv.x, 1.0-uv.y));

    vec3 col = 0.5 + 0.5 * cos(time + uv.xyx * vec3(0, 2, 4));

    col.rgb *= t.rgb;

    gl_FragColor = vec4(col, 0.1);
}
