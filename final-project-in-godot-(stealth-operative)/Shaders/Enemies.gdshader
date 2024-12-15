shader_type canvas_item;

uniform float damage_flash : hint_range(0.0, 1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    if (damage_flash > 0.0) {
        COLOR = vec4(0.8, tex_color.g * 0.3, tex_color.b * 0.3, tex_color.a);
    } 
	else{
        COLOR = tex_color;
    }
}