shader_type canvas_item;

uniform vec2 light_position = vec2(0.5, 0.5);
uniform float light_radius = 0.3;
uniform float darkness = 0.7;

void fragment() {
    float dist = distance(FRAGCOORD, light_position);
    float falloff = smoothstep(light_radius, 0., dist);
    COLOR = vec4(0., 0., 0., mix(darkness, 0., falloff));
}
