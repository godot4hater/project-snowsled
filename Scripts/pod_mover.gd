extends Node3D

const POD_SPEED : float			= 0.08
var moveDirection : Vector3 	= Vector3.ZERO

func _physics_process (delta : float) -> void:
	MovePod (delta, moveDirection)
			
func MovePod (delta, direction : Vector3) -> void:
	if global_position.x < 34.0 and global_position.z < 34.0 and \
	  global_position.x > -34.0 and global_position.z > -34.0:
		global_translate (direction * POD_SPEED * delta)
