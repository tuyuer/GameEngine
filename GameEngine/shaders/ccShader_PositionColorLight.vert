attribute vec4 a_position;
attribute vec3 a_normal;

uniform mat3 u_normalMatrix;

uniform vec3 u_lightPosition;
uniform vec3 u_lightDirection;

uniform vec3 u_lightAmbient;
uniform vec3 u_lightDiffuse;
uniform vec3 u_lightSpecular;

uniform float u_lightShiness;

varying vec2 v_texCoord;
varying vec4 v_fragmentColor;								
										
void main()						
{
    vec3 N = u_normalMatrix * a_normal;
    vec3 L = normalize(u_lightPosition);
    vec3 E = u_lightDirection;
    vec3 H = normalize(L + E);
    
    float df = max(0.0, dot(N, L));
    float sf = max(0.0, dot(N, H));
    sf = pow(sf, u_lightShiness);
    
    vec3 color = u_lightAmbient + df * u_lightDiffuse + sf * u_lightSpecular;
         
    gl_Position = CC_MVPMatrix * a_position;
	v_fragmentColor = vec4(color,1);
}