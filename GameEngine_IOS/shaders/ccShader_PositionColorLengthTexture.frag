#extension GL_OES_standard_derivatives : enable	

varying vec4 v_color;
varying vec2 v_texcoord;		
											
void main()									
{		
    gl_FragColor = v_color * step(0.0, 1.0 - length(v_texcoord));	
}									

