extends Camera3D

@onready var Player : CharacterBody3D			= get_parent()
@onready var radarBeepSnd : AudioStreamPlayer3D = $RadarBeep
@onready var podObj : Node3D					= get_parent().get_parent()

const CAM_TURN_SPEED : float 					= 500.0
const POD_SPEED : float							= 0.075
const MAX_RADAR_DISTANCE : float 				= 25.0  
const MIN_PULSE : float 						= 0.05
const MAX_PULSE : float 						= 2.0    
const RAY_LENGTH : float 						= 20.0

var radarTimer : Timer
var moveDirection : Vector3 					= Vector3.ZERO

func _ready() -> void:
	Input.set_mouse_mode (Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode (Input.MOUSE_MODE_CAPTURED)
	radarTimer = Timer.new()
	radarTimer.one_shot = true
	radarTimer.timeout.connect(_on_radar_timer_finished)
	add_child (radarTimer)
	FindMineRange()
	set_process_input (true)

func _physics_process (delta : float) -> void:
	MovePod (delta, moveDirection)
			
func MovePod (delta, direction : Vector3) -> void:
	podObj.global_translate (direction * POD_SPEED * delta)
	
func _input (event) -> void:
	moveDirection = Vector3.ZERO
	
	if Input.is_action_pressed ("E"):
		var directSpaceState = get_world_3d().direct_space_state
		var rayStart = global_position
		var rayEnd = rayStart + (-global_basis.z * RAY_LENGTH)  
		var temp = PhysicsRayQueryParameters3D.create (rayStart, rayEnd)
		temp.collision_mask = 2  
		temp.collide_with_areas = true
		temp.collide_with_bodies = false
		
		var res = directSpaceState.intersect_ray (temp)
		
		if res:
			if res.collider.is_in_group ("Left"):
				moveDirection = Vector3.LEFT
			elif res.collider.is_in_group ("Right"):
				moveDirection = Vector3.RIGHT
			elif res.collider.is_in_group ("Up"):
				moveDirection = Vector3.FORWARD
			elif res.collider.is_in_group ("Down"):
				moveDirection = Vector3.BACK
			
	if event is InputEventMouseMotion:		
		Player.set_rotation (LeftRightRot (event.relative.x / -CAM_TURN_SPEED))
		self.set_rotation (UpDownRot (event.relative.y / -CAM_TURN_SPEED))
	
	print (global_position)
	
func UpDownRot (newRotation : float) -> Vector3:
	var tempRot = self.get_rotation() + Vector3 (newRotation, 0, 0)
	tempRot.x = clamp(tempRot.x, PI / -2, PI / 2)
	
	return tempRot

func LeftRightRot (newRotation : float) -> Vector3:
	return Player.get_rotation() + Vector3 (0, newRotation, 0)
	
func FindMineRange () -> void:
	var nearestMine = get_tree().get_nodes_in_group ("MineObj")
	#this should actually try to find the nearest mine to the player, dunno how it would handle multiple of them
	#right now it just gets whatever is first in the group which is undeterminable what the first one is based on distance
	
	if nearestMine.is_empty():
		ResetRadarTimer (MAX_RADAR_DISTANCE)
		return

	var curDistance = global_position.distance_to (nearestMine[0].global_position)
	
	if curDistance > MAX_RADAR_DISTANCE:
		ResetRadarTimer (MAX_RADAR_DISTANCE)
		return  

	var temp = curDistance / MAX_RADAR_DISTANCE
	var delay = lerp (MIN_PULSE,MAX_PULSE, temp)
	radarBeepSnd.play()
	ResetRadarTimer (delay)

func _on_radar_timer_finished():
	FindMineRange()

func ResetRadarTimer (x : float) -> void:
	radarTimer.wait_time = x
	radarTimer.start()

func _on_mine_hurt_box_area_shape_entered(_area_rid: RID, area: Area3D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area.get_parent().is_in_group ("MineObj"):
		get_tree().quit()
