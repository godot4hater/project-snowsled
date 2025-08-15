extends ColorRect

func _ready() -> void:
	color.a = 0
	
func FadeToBlack() -> void:
	var x = create_tween()
	x.tween_property (self, "color:a", 1.0, 2.0)
	x.tween_callback (func(): await get_tree().create_timer (5.0).timeout)
	await x.finished
	await get_tree().process_frame
	await get_tree().create_timer (2.0).timeout
