extends ColorRect

@export var corners: Control

var t:float

func _process(delta: float) -> void:
	t += delta
	corners.modulate.a = cos(t * 4) + 1.0
