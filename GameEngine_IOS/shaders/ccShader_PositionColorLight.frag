
uniform vec3 u_lightPosition;
uniform vec3 u_lightDirection;

uniform vec3 u_lightAmbient;
uniform vec3 u_lightSpecular;
uniform float u_lightShiness;


varying vec3 v_eyespaceNormal;
varying vec3 v_diffuse;
                                                                							
void main()							
{				

    vec3 N = v_eyespaceNormal;
    vec3 L = normalize(u_lightPosition);
    vec3 E = u_lightDirection;
    vec3 H = normalize(L + E);
    
    float df = max(0.0, dot(N, L));
    float sf = max(0.0, dot(N, H));
   
    sf = pow(sf, u_lightShiness);
    
    vec3 color = u_lightAmbient + df * v_diffuse + sf * u_lightSpecular;
    
	gl_FragColor = vec4(color,1.0);
}								
