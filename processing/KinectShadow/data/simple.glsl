#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 res;
uniform vec2 resolution;
uniform float freq0;
uniform sampler2D cam;

void main() {
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = gl_FragCoord.xy / res.xy;
    vec4 t = texture2D(cam, vec2(uv.x, 1-uv.y));

    vec3 col = 0.5 + 0.5*cos(time+uv.xyx+vec3(0,2,4));
    col.rgb *= t.rgb;

    // Output to screen
    gl_FragColor = vec4(col,1.0);
}
