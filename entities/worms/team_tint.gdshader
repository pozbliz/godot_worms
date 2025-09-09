shader_type canvas_item;

uniform vec4 team_color;
uniform float tint_strength : hint_range(0.0, 1.0) = 0.3;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    COLOR = mix(tex, tex * team_color, tint_strength);
}
