extends Area3D
@export var podObj : Node3D
@export var moveSnd : AudioStreamPlayer3D

func Interact() -> void:
	podObj.moveDirection = Vector3.FORWARD
	get_parent().material.emission = Color.RED
	
	if not moveSnd.playing:
		moveSnd.play()

func NotInteractedWith() -> void:
	moveSnd.stop()
	get_parent().material.emission = Color ("85e600")
