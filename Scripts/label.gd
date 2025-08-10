extends Label

var depth : int = 9999

func _process (delta : float) -> void:
	if int(delta * 10000.0) % 10 == 0:
		depth -= 1 
		
	self.text = "Depth: " + str (depth)
