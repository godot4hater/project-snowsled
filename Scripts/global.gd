extends Node

var radar_beeps_enabled: bool = true
var hp : int = 100
@onready var hullLabel : Label 	= get_tree().get_root().get_node ("World/EscapepodMesh/DiagnosticPanel/SubViewport/ShuttleStatusPanel/MarginContainer/VBoxContainer/HullLabel")
@onready var model :  Node3D 	= get_tree().get_root().get_node ("World/EscapepodMesh/Player")
@onready var FTB : ColorRect 	= get_tree().get_root().get_node ("World/EscapepodMesh/PlayerSizeReference/CanvasLayer/FTB")
@onready var losecon : Label 	= get_tree().get_root().get_node ("World/LOSECON")
@onready var wincon : Label 	= get_tree().get_root().get_node ("World/WINCON")
@onready var pilot : Node3D 	= get_tree().get_root().get_node ("World/EscapepodMesh/PilotV2")

func _ready() -> void:
	pilot.anim_tree["parameters/TorsoState/transition_request"] = "right"
	await get_tree().create_timer (2.5).timeout
	RandomAnim()
	
func TakeDmg() -> void:
	hp -= 50
	hullLabel.ReduceHP()
	pilot.anim_tree["parameters/TorsoState/transition_request"] = "right"
	
	if hp <= 0:
		StartDeathCD()

func StartDeathCD() -> void:
	pilot.anim_tree["parameters/TorsoState/transition_request"] = "right"
	losecon.visible = true
	await get_tree().create_timer (0.5).timeout
	get_tree().quit()

func PlayerWin() -> void:
	pilot.anim_tree["parameters/TorsoState/transition_request"] = "right"
	model.thumbs_up()
	wincon.visible = true
	await FTB.FadeToBlack()
	await get_tree().create_timer (0.5).timeout
	get_tree().quit()

func RandomAnim() -> void:
	var x = randf()
	
	if x > 0.5:
		pilot.anim_tree["parameters/TorsoState/transition_request"] = "forward"
	else:
		pilot.anim_tree["parameters/TorsoState/transition_request"] = "right"
		
	var y = randf_range(5.0, 10.0) 
	await get_tree().create_timer (y).timeout
	RandomAnim()  
