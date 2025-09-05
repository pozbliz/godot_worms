shader_type canvas_item;

uniform bool flash = false;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (flash) {
		COLOR.rgb = vec3(1.0);
	}
}
