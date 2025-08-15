extends Label

var fuel : int = 100
var timer : Timer

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = 4
	timer.timeout.connect (Dummy)
	add_child (timer)
	timer.start()

func Dummy() -> void:
	await get_tree().create_timer (4).timeout
	fuel -= 1
	
	if fuel <= 0:
		fuel = 0
		timer.stop()
		
	self.text = "Fuel: " + str (fuel) + "%"
