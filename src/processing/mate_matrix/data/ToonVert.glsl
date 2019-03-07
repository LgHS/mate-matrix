
uniform mat4 transform;
uniform mat3 normalMatrix;
uniform vec3 lightNormal;

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;

uniform float u_time;
uniform float u_mouse;

void main()
{

	gl_Position = transform *
												vec4(
													vertex.x*floor(sin(u_time/10.*cos(vertex.x))-sin(vertex.x)*.7)	,
													vertex.y*pow(cos(vertex.y+u_time/10.),2.3),
													vertex.z*1.2,
													vertex.w

												);
	//gl_Position = transform * vertex;
	/*
	gl_Position = transform *
									vec4(
											distance(vertex.x, ceil(pow(sin(vertex.x*100.0),4.0))+pow(cos(vertex.x+u_time/2.0),3.0)*vertex.x*1.3)-length(vertex.xy),
											cos(vertex.x+u_time)+sin(vertex.y)*vertex.y/2.0,
											sin(vertex.y*100.0)*vertex.z/2.0,
											vertex.w
										);
	*/
	vertColor = color;
	vertNormal = normalize(normalMatrix * normal);
	vertLightDir = -lightNormal;

}
