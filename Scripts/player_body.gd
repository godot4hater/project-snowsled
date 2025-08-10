extends Node3D

@export var hand_anim_player: AnimationPlayer

signal thumbsed_up

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("thumbs_up"):
		thumbs_up()

func thumbs_up() -> void:
	hand_anim_player.play("thumbs_up")
	thumbsed_up.emit()
