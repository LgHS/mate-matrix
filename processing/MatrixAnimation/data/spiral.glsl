// adapted to processing shaders from https://www.shadertoy.com/view/4st3WX
#define PROCESSING_COLOR_SHADER
#define PI 3.14159265359

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

 void main(void)
 {
   vec2 uv = (gl_FragCoord.xy / resolution.xy) / .5 -1.;
   uv.x *= resolution.x / resolution.y;

   float f = 1. / length(uv);
   f+= atan(uv.x, uv.y) / acos(0.);

   f -= time;

   f = 1.0-clamp(sin(f * PI * 2.) * dot(uv, uv) * resolution.y / 150. + .5, 0., 1.);

   f*= sin(length(uv) - .19);

   gl_FragColor = vec4(vec3(f),1.0);
 }
