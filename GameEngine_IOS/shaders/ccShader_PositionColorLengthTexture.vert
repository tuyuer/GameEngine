attribute vec4 a_position;
attribute vec4 a_color;
attribute vec2 a_texCoord;					
																						
varying vec4 v_color;										
varying vec2 v_texcoord;

void main()									
{											
    v_color = vec4(a_color.rgb * a_color.a, a_color.a);	
    v_texcoord = a_texCoord;
    gl_Position = CC_MVPMatrix * a_position;
}												
