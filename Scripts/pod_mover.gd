extends Node3D

@export var explodeSnd : AudioStreamPlayer3D 
@export var cam : Camera3D
@export var water : MeshInstance3D
const POD_SPEED : float			= 0.2
const MAX_MAP_XZ_LIMITS : float = 30.0
var shakeVal : float 			= 0.65
var moveDirection : Vector3 	= Vector3.ZERO

func _physics_process (delta : float) -> void:
	MovePod (delta, moveDirection)
			
func MovePod (delta, direction : Vector3) -> void:
	if global_position.x < MAX_MAP_XZ_LIMITS and global_position.z < MAX_MAP_XZ_LIMITS and \
	  global_position.x > -MAX_MAP_XZ_LIMITS and global_position.z > -MAX_MAP_XZ_LIMITS:
		global_translate (direction * POD_SPEED * delta)
	#print(global_position)
	
func _on_area_3d_area_entered (area: Area3D) -> void:
	if area.get_parent().is_in_group ("MineObj"):
		explodeSnd.play()
		var tween = create_tween()
		var x = cam.transform.origin
			
		for i in 20:
			var offset = Vector3 (randf_range (-shakeVal , shakeVal), randf_range (-shakeVal , shakeVal), 0)
			var temp = cam.transform.basis * offset
			tween.tween_property(cam, "transform:origin", temp + x, 0.05)
			shakeVal *= 0.95
	
		tween.tween_property (cam, "transform:origin", x, 0.1)
		area.get_parent().queue_free()
		Global.TakeDmg()
		water.global_position += Vector3(0, 0.2, 0)
