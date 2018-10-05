// stolen from Akufishi on ShaderToy https://www.shadertoy.com/view/lscBRf 
// adapted to Procesing by gberger

#define FALLING_SPEED  0.05
#define STRIPES_FACTOR 55.0

uniform float time;
uniform vec2 resolution;
uniform sampler2D cam;

//get sphere
float sphere(vec2 coord, vec2 pos, float r) {
    vec2 d = pos - coord; 
    return smoothstep(60.0, 0.0, dot(d, d) - r * r);
}

//main
void main(void)
{
    float t = time*0.8;
    //normalize pixel coordinates
    vec2 uv         = gl_FragCoord.xy / resolution.xy;
    // yeah
    vec4 tex = texture2D(cam, vec2(uv.x, 1.0-uv.y));
    //pixellize uv
    vec2 clamped_uv = (round(gl_FragCoord.xy / STRIPES_FACTOR) * STRIPES_FACTOR) / resolution.xy;
    //get pseudo-random value for stripe height
    float value		= fract(sin(clamped_uv.x) * 43758.5453123);
    //create stripes
    vec3 col        = vec3(1.0 - mod(uv.y * 0.5 + (t * (FALLING_SPEED + value / 5.0)) + value, 0.5));
    //add color
         col       *= clamp(cos(t* 2.0 + uv.xyx + vec3(0, 2, 4)), 0.0, 1.0);
    //add glowing ends
    	 col 	   += vec3(sphere(gl_FragCoord.xy, 
                                  vec2(clamped_uv.x, (1.0 - 2.0 * mod((t * (FALLING_SPEED + value / 5.0)) + value, 0.5))) * resolution.xy, 
                                  8)); 
    //add screen fade
      //  col       *= vec3(exp(-pow(abs(uv.y - 0.5), 6.0) / pow(2.0 * 0.05, 2.0)));
    // Output to screen
    col.rgb *= 1 - tex.rgb;
    gl_FragColor       = vec4(col,1.0);
} 