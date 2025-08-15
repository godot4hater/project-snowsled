extends Node3D

const SPEED_DOWN : float 				= 0.01
const MAX_MAP_GLOBALPOS_LIMIT : float 	= -10.0

func _ready() -> void:
	pass
	
func _phyiscs_process (_delta: float) -> void:
	if global_position.y < MAX_MAP_GLOBALPOS_LIMIT:
		queue_free()
	
func _physics_process (_delta : float) -> void:
	self.global_translate (Vector3.DOWN * SPEED_DOWN)
