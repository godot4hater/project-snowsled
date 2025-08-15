extends Panel

func _ready() -> void:
	hide()
	
	%ToggleBeeps.toggled.connect(_radar_beep_toggle)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cheats"):
		visible = not visible
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if not visible else Input.MOUSE_MODE_VISIBLE

func _radar_beep_toggle(toggled: bool) -> void:
	Global.radar_beeps_enabled = toggled
