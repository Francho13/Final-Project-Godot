shader_type canvas_item;


uniform float damage_flash : hint_range(0.0, 1.0);
uniform float blink : hint_range(0.0, 1.0);
uniform float blink_time = 0.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    if (blink > 0.0 && mod(blink_time * 10.0, 1.0) > 0.5) {
        COLOR = vec4(tex_color.rgb, tex_color.a * 0.3);
    }
	else if (damage_flash > 0.0) {
        COLOR = vec4(tex_color.r * 0.3, 0.8, tex_color.b * 0.3, tex_color.a);
    }
	else {
        COLOR = tex_color;
    }
}