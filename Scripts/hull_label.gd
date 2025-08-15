extends Label

func ReduceHP() -> void:
	if (Global.hp > 0):
		self.text = "Hull Integrity: " + str (Global.hp) + "%"
		if Global.hp == 50:
			self.label_settings.font_color = Color.RED
	else:
		self.text = "Hull Integrity: 0%"
