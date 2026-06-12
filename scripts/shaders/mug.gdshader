shader_type canvas_item;

const float MIN_BLUR = 0.;
const float MAX_BLUR = 5.;

// To use the screen as texture
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float blur_intensity = 0.;
uniform float gaussian_blur_center = 0.25;
uniform float gaussian_blur_edge = 0.125;
uniform float gaussian_blur_corner = 0.0625;

void fragment() {
	vec3 colour = vec3(0.);

	if(blur_intensity > 0.) {
		// Same as percentage
		float offset = blur_intensity * 0.01;

		colour += texture(SCREEN_TEXTURE, UV + vec2(-2.0, -2.0) * offset).rgb * gaussian_blur_corner;
		colour += texture(SCREEN_TEXTURE, UV + vec2(-1.0, -2.0) * offset).rgb * gaussian_blur_edge;
		colour += texture(SCREEN_TEXTURE, UV + vec2(0.0, -2.0) * offset).rgb * gaussian_blur_corner;
		colour += texture(SCREEN_TEXTURE, UV + vec2(-2.0, -1.0) * offset).rgb * gaussian_blur_edge;
		colour += texture(SCREEN_TEXTURE, UV).rgb * gaussian_blur_center;
		colour += texture(SCREEN_TEXTURE, UV + vec2(2.0, -1.0) * offset).rgb * gaussian_blur_edge;
		colour += texture(SCREEN_TEXTURE, UV + vec2(-2.0, 0.0) * offset).rgb * gaussian_blur_corner;
		colour += texture(SCREEN_TEXTURE, UV + vec2(-1.0, 2.0) * offset).rgb * gaussian_blur_edge;
		colour += texture(SCREEN_TEXTURE, UV + vec2(0.0, 2.0) * offset).rgb * gaussian_blur_corner;
	} else {
		colour = texture(SCREEN_TEXTURE, UV).rgb;
	}

	COLOR = vec4(colour, 1.);
}