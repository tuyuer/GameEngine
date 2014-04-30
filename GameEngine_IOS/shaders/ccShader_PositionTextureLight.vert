attribute vec4 a_position;
attribute vec3 a_normal;
attribute vec2 a_texCoord;	

uniform mat3 u_normalMatrix;
uniform vec3 u_lightDiffuse;

varying vec3 v_eyespaceNormal;	
varying vec3 v_diffuse;

varying vec2 v_texCoord;	


void main()
{			
    v_eyespaceNormal = u_normalMatrix * a_normal;
    v_diffuse = u_lightDiffuse;									
    gl_Position = CC_MVPMatrix * a_position;			
    v_texCoord = a_texCoord;
}													
