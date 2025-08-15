shader_type spatial;

uniform sampler2D water_texture : source_color;
uniform float speed : hint_range(0.05, 3.0) = 0.5;
uniform float wave_strength : hint_range(0.05, 0.5) = 0.05;

void fragment() {
    vec2 uv = UV;
    float time_offset = TIME * speed;
    uv.y += time_offset * 0.1;
    uv.x += sin(uv.y * 20.0 + time_offset * 3.0) * wave_strength;
    uv.x += sin(uv.y * 15.0 - time_offset * 2.0) * wave_strength * 0.5;
    ALBEDO = texture(water_texture, uv).rgb;
}