shader_type canvas_item;

// Estas variables aparecerán en el Inspector
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Blanco por defecto
uniform float flash_modifier : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	// Obtenemos el color original del pixel del sprite
	vec4 color = texture(TEXTURE, UV);
	
	// Mezclamos el color original con el color del flash basándonos en el modificador
	color.rgb = mix(color.rgb, flash_color.rgb, flash_modifier);
	
	// Le devolvemos el color final a Godot
	COLOR = color;
}
