extends Label

var depth : int = 9999
var timer : Timer

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = 0.04
	timer.timeout.connect (Dummy)
	add_child (timer)
	timer.start()

func Dummy() -> void:
	await get_tree().create_timer (0.04).timeout
	depth -= 1
	
	if depth <= 0:
		depth = 0
		timer.stop()
		Global.PlayerWin()
		
	self.text = "Depth: " + str (depth)
