shader_type canvas_item;

uniform vec4 team_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float tint_strength : hint_range(0.0, 1.0) = 0.20; // 0 = no tint, 1 = full replace

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    vec3 out_rgb = mix(tex.rgb, team_color.rgb, tint_strength);
    COLOR = vec4(out_rgb, tex.a);
}
