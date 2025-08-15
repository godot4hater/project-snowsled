extends Label

@onready var FTB : ColorRect = get_tree().get_root().get_node ("World/EscapepodMesh/PlayerSizeReference/CanvasLayer/FTB")
@onready var losecon : Label = get_tree().get_root().get_node ("World/LOSECON")
var oxygen : int			= 100
var isOn : bool 			= false
var switchFlipped : bool 	= false

func _ready():
	get_tree().create_timer (randf_range (7,20)).timeout.connect (TimerHolder)

func IsAlreadyRunning():
	if not isOn:
		get_tree().create_timer (randf_range (60, 120)).timeout.connect (StartCD)
		
func Looping():
	if isOn:
		oxygen -= 1
		
		if oxygen > 0:
			text = "Oxygen: " + str (oxygen) + "%"
			label_settings.font_color = Color.RED
		else:
			losecon.visible = true
			await FTB.FadeToBlack()
			get_tree().quit()
			
	if switchFlipped:
		switchFlipped = false
		oxygen = 100
		text = "Oxygen: 100%"
		label_settings.font_color = Color ("00ff00")
		isOn = false
		IsAlreadyRunning()

func TimerHolder() -> void:
	StartCD()
	var timer = Timer.new()
	add_child (timer)
	timer.start()
	timer.wait_time = 0.33
	timer.timeout.connect (Looping)
	
func StartCD() -> void:
	isOn = true
