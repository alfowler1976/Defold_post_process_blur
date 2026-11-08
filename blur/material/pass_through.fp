#version 140

in vec2 var_texcoord0;
out vec4 color_out;

uniform sampler2D texture_sampler;

void main()
{
	color_out = texture(texture_sampler, var_texcoord0);
}