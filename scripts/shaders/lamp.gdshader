shader_type canvas_item;

uniform vec2 light_marker = vec2(0.5, 0.5);
uniform float light_radius = 0.75;
uniform float darkness_alpha = 0.65;
uniform float light_intensity = 1.;
uniform bool circular_light = false;

void fragment() {
    float dist;
    if(circular_light) {
        float aspect = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
        vec2 aspect_uv = vec2(aspect * UV.x, UV.y);

        vec2 aspect_light_marker = light_marker;
        aspect_light_marker = vec2(aspect * aspect_light_marker.x, aspect_light_marker.y);

        dist = distance(aspect_uv, aspect_light_marker);
    } else {
        dist = distance(UV, light_marker);
    }
    
    float falloff = smoothstep(light_radius, 0., dist);
    float alpha = mix(darkness_alpha, (1.0 - light_intensity), falloff);
    COLOR = vec4(0., 0., 0., mix(darkness_alpha, alpha, falloff));
}
