#version 140

in vec2 var_texcoord0;
out vec4 color_out;

uniform sampler2D texture_sampler;

uniform fs_uniforms {
	vec4 u_resolution;
	vec4 u_blur_size; // x = blur size 
	vec4 u_direction; // xy = u_direction
};

const float offsets[5] = float[](
	1.47804, 
	3.44885, 
	5.42006, 
	7.39194, 
	9.36476
);

const float weights[5] = float[](
	0.181856, 
	0.136976, 
	0.080550, 
	0.036978, 
	0.013254
);

const float center_weight = 0.099972;

void main()
{
	float size = u_blur_size.x; 
	vec2 uv = var_texcoord0;

	vec2 dir_step = (1.0 / u_resolution.xy) * u_direction.xy * (size * 0.25);

	// center pixel contribution
	vec4 color = texture(texture_sampler, uv) * center_weight;

	// 5 bilinear pairs on each side = 20 outer pixels blended in 10 fetches
	for (int i = 0; i < 5; i++)
	{
		vec2 off = dir_step * offsets[i];
		color += texture(texture_sampler, uv + off) * weights[i];
		color += texture(texture_sampler, uv - off) * weights[i];
	}

	color_out = color;
}