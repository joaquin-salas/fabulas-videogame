extends CanvasLayer

@onready var rect = $ColorRect

func set_brightness(value: float):

	value = clamp(value, 0.5, 1.5)

	if value < 1.0:
		# Oscurecer
		rect.color = Color(0, 0, 0, 1.0 - value)

	elif value > 1.0:
		# Aclarar
		var alpha = (value - 1.0) * 0.3
		rect.color = Color(1, 1, 1, alpha)

	else:
		# Normal
		rect.color = Color(0, 0, 0, 0)
