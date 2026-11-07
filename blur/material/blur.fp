#version 140

in vec2 var_texcoord0;
out vec4 color_out;

uniform sampler2D texture_sampler;

uniform fs_uniforms {
	vec4 u_resolution;
	vec4 u_blur_size; // x = blur size
	vec4 u_direction; // xy = u_direction (1.0, 0.0 or 0.0, 1.0)
};

const float offsets[4] = float[](
	1.44505, 
	3.37362, 
	5.30498, 
	7.23989
);

const float weights[4] = float[](
	0.233881, 
	0.145353, 
	0.056971, 
	0.014068
);

const float center_weight = 0.099454;

void main()
{
	float size = u_blur_size.x; 
	vec2 uv = var_texcoord0;

	// early exit if blur is off
	if (size <= 0.001) 
	{
		color_out = texture(texture_sampler, uv);
		return;
	}

	vec2 dir_step = (1.0 / u_resolution.xy) * u_direction.xy * (size * 0.25);

	// center pixel contribution
	vec4 color = texture(texture_sampler, uv) * center_weight;

	// 4 bilinear pairs on each side = 16 outer pixels blended in 8 fetches
	for (int i = 0; i < 4; i++)
	{
		vec2 off = dir_step * offsets[i];
		color += texture(texture_sampler, uv + off) * weights[i];
		color += texture(texture_sampler, uv - off) * weights[i];
	}

	color_out = color;
}