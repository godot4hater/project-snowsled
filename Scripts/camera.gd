extends Camera3D

@export var Player : CharacterBody3D		
@export var radarBeepSnd : AudioStreamPlayer3D
@export var podObj : Node3D
@export var interestPoint : Marker3D

const CAM_TURN_SPEED : float 					= 500.0
const MAX_RADAR_DISTANCE : float 				= 27.0  
const MIN_PULSE : float 						= 0.25
const MAX_PULSE : float 						= 3.0    
const RAY_LENGTH : float 						= 20.0
const MAX_LOOK_SIDES_ANGLE : float				= 1.5
const MAX_LOOK_UP_ANGLE : float					= 0.1

var radarTimer : Timer
var closeMineTemp : float						= 0.0

func _ready() -> void:
	Input.set_mouse_mode (Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode (Input.MOUSE_MODE_CAPTURED)
	radarTimer = Timer.new()
	radarTimer.one_shot = true
	radarTimer.timeout.connect (_on_radar_timer_finished)
	add_child (radarTimer)
	BeepMineRange()
	set_process_input (true)

func _physics_process (_delta) -> void:
	var viewport = get_viewport()
	var center = viewport.get_visible_rect().size / 2
	var lookingAtPoint = project_position (center, 1.0)
	interestPoint.global_position = lookingAtPoint
	
func _input (event) -> void:
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
			res.collider.Interact()
		else:
			var allInteractables =  get_tree().get_nodes_in_group ("Interactable")
			podObj.moveDirection = Vector3.ZERO
			
			for i in allInteractables:
				i.NotInteractedWith()
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:		
		Player.set_rotation (LeftRightRot (event.relative.x / -CAM_TURN_SPEED))
		self.set_rotation (UpDownRot (event.relative.y / -CAM_TURN_SPEED))
	
	if Input.is_action_just_released ("E"):
		var allInteractables =  get_tree().get_nodes_in_group ("Interactable")
		podObj.moveDirection = Vector3.ZERO
			
		for i in allInteractables:
			i.NotInteractedWith()
	
func UpDownRot (newRotation : float) -> Vector3:
	var tempRot = self.get_rotation() + Vector3 (newRotation, 0, 0)
	tempRot.x = clamp(tempRot.x, MAX_LOOK_UP_ANGLE, PI / 2)
	
	return tempRot

func LeftRightRot (newRotation : float) -> Vector3:
	var tempRot = Player.get_rotation() + Vector3 (0, newRotation, 0)
	tempRot.y = clamp(tempRot.y, -MAX_LOOK_SIDES_ANGLE, MAX_LOOK_SIDES_ANGLE)
	
	return tempRot
	
func BeepMineRange () -> void:
	var minesList = get_tree().get_nodes_in_group ("MineObj")
	
	if minesList.is_empty():
		ResetRadarTimer (MAX_RADAR_DISTANCE)
		return

	var closestDistance = INF
	
	for mine in minesList:
		var curDistance = global_position.distance_to (mine.global_position) - 6.0
		
		if curDistance < closestDistance:
			closestDistance = curDistance
			
	closeMineTemp = closestDistance
		
	if closeMineTemp > MAX_RADAR_DISTANCE:
		ResetRadarTimer (MAX_RADAR_DISTANCE)
		return  
	
	if closeMineTemp < 0.0:
		closeMineTemp = 0.0
	
	var temp = closeMineTemp  / MAX_RADAR_DISTANCE
	var delay = lerp (MIN_PULSE, MAX_PULSE, temp)
	
	if Global.radar_beeps_enabled: radarBeepSnd.play()
	
	#bandaid: i dont know why i need to speed it up
	ResetRadarTimer (delay)

func _on_radar_timer_finished():
	BeepMineRange()

func ResetRadarTimer (x : float) -> void:
	radarTimer.wait_time = x
	radarTimer.start()
