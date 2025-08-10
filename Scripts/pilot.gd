@tool
class_name Pilot
extends Node3D

@export var head: MeshInstance3D
@export var anim_tree: AnimationTree

func _ready() -> void:
	$BlinkTimer.timeout.connect(blink)
	$BlinkTimer.start()

func blink() -> void:
	#print("blink")
	var t_l = create_tween()
	t_l.tween_property(head, "blend_shapes/EyeCloseLeft", 1.0, 0.1)
	t_l.tween_interval(0.1)
	t_l.tween_property(head, "blend_shapes/EyeCloseLeft", 0.0, 0.2)
	await get_tree().create_timer(randf_range(0.01, 0.02)).timeout
	var t_r = create_tween()
	t_r.tween_property(head, "blend_shapes/EyeCloseRight", 1.0, 0.1)
	t_r.tween_interval(0.1)
	t_r.tween_property(head, "blend_shapes/EyeCloseRight", 0.0, 0.2)
	
	await t_r.finished
	
	$BlinkTimer.start(randf_range(1.2, 2.4))


func _on_player_thumbsed_up() -> void:
	var t = create_tween()
	t.tween_interval(1.0)
	t.tween_property(head, "blend_shapes/JawOpen", 1.0, 0.25)
	t.tween_interval(1.5)
	t.tween_property(head, "blend_shapes/JawOpen", 0.0, 0.25)
	
	await t.finished
	anim_tree["parameters/TorsoState/transition_request"] = "forward"
