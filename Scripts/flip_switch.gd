extends Node3D

@onready var mesh : MeshInstance3D 	= get_parent()
@onready var tween: Tween
@export var switchSnd : AudioStreamPlayer3D
@onready var oxyLabel : Label = get_tree().get_root().get_node ("World/EscapepodMesh/DiagnosticPanel/SubViewport/ShuttleStatusPanel/MarginContainer/VBoxContainer/OxygenLabel")

const MAX_ROTATION : float 			= 100
const MAX_Z_POS : float 			= 0.05

var openState : bool 				= true
var isOn : bool 					= false

func Interact() -> void:
	if not openState or (tween and tween.is_valid()):
		return
		
	switchSnd.play (0.3)
	openState = false
	tween = create_tween()
	var rotations = MAX_ROTATION if !isOn else -MAX_ROTATION
	var newRotation = mesh.rotation_degrees.z + rotations
	tween.tween_property (mesh, "rotation_degrees:z", newRotation, MAX_Z_POS)
	isOn = !isOn
	await get_tree().create_timer (0.3).timeout
	openState = true

	if mesh.name == "ResetOxy":
		oxyLabel.switchFlipped = true
	#cool misleading name that i regret making, im not coding a fuel mechanic fuck that
	elif mesh.name == "ResetFuel":
		Global.radar_beeps_enabled = !Global.radar_beeps_enabled
	
func NotInteractedWith():
	pass
