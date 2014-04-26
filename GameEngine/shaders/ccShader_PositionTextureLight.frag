varying vec2 v_texCoord;										
uniform sampler2D CC_Texture0;
varying vec4 v_fragmentColor;	

void main()														
{																
    gl_FragColor =  v_fragmentColor * texture2D(CC_Texture0, v_texCoord);				
}																	
