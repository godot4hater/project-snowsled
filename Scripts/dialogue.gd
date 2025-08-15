extends Control

@onready var words = $Box/Text
@onready var box = $Box
@onready var talkingSnd = $Box/TalkingSnd

var dialogue : Array[String]	= ["Hey, you're awake!", "Unfortunately, the dialogue writer quit this project,", "so there's no tutorial or anything.", "Sorry.", "The only control is one button 'E', good luck!"]
var curLine : int 				= 0
const speed : float 			= 0.05

func _ready():
	box.visible = false
	Start()

func Start():
	box.visible = true
	curLine = 0
	Show()

func Show():
	words.text = ""
	talkingSnd.play()
	
	var tween = create_tween()
	var allText = dialogue[curLine]
	
	for i in range (allText.length() + 1):
		tween.tween_callback (MoveNewText.bind (allText.substr (0, i))).set_delay (speed)
		
	tween.tween_callback (NextLine).set_delay (1.0)

func MoveNewText (text: String) -> void:
	words.text = text

func NextLine() -> void:
	curLine += 1
	if curLine < dialogue.size():
		Show()
	else:
		box.visible = false
