extends Area3D
@onready var podObj : Node3D = get_parent().get_parent().get_parent()
@export var moveSnd : AudioStreamPlayer3D

func Interact():
	podObj.moveDirection = Vector3.RIGHT
	get_parent().material.emission = Color.RED
	
	if not moveSnd.playing:
		moveSnd.play()

func NotInteractedWith() -> void:
	moveSnd.stop()
	get_parent().material.emission = Color("85e600")
