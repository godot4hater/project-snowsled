extends Node3D

const SPEED_DOWN : float = 0.01

func _ready() -> void:
	pass
	
func _process (_delta: float) -> void:
	pass
	
func _physics_process (_delta : float) -> void:
	self.global_translate (Vector3.DOWN * SPEED_DOWN)
