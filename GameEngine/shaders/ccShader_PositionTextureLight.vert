attribute vec4 a_position;			
attribute vec2 a_texCoord;
attribute vec3 a_normal;

uniform vec4 u_lightPosition;
uniform vec4 u_lightDirection;

uniform vec4 u_lightAmbient;
uniform vec4 u_lightDiffuse;
uniform vec4 u_lightSpecular;

varying vec2 v_texCoord;	
varying vec4 v_fragmentColor;


void main()
{												
    gl_Position = CC_MVPMatrix * a_position;			
    v_texCoord = a_texCoord;
    v_fragmentColor = vec4(1,1,1,1);
}													
