
#extension GL_OES_standard_derivatives : enable	

varying vec4 v_color;
varying vec2 v_texcoord;		
											
void main()									
{		
								
#if defined GL_OES_standard_derivatives																						
	gl_FragColor = v_color*smoothstep(0.0, length(fwidth(v_texcoord)), 1.0 - length(v_texcoord));							
#else																														
	gl_FragColor = v_color*step(0.0, 1.0 - length(v_texcoord));															
#endif	

}										

