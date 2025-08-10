extends Node3D

var mineScene: PackedScene 				= preload ("res://Scenes/mine.tscn")
const AREA_WHERE_MINES_SPAWN : Vector2 	= Vector2 (35, 35)
const HEIGHT_FROM_ORIGIN : float 			= 30.0
const RAND_SECONDS_RANGE : Vector2 		= Vector2 (7.0, 15.0)

func _ready() -> void:
	WaitForTree()

func WaitForTree() -> void:
	await get_tree().create_timer (randf_range (RAND_SECONDS_RANGE.x, RAND_SECONDS_RANGE.y)).timeout
	SpawnMine()
	WaitForTree()

func SpawnMine() -> void:
	var mineObj = mineScene.instantiate()
	var x = randf_range (-AREA_WHERE_MINES_SPAWN.x / 2, AREA_WHERE_MINES_SPAWN.x / 2)
	var y = randf_range (-AREA_WHERE_MINES_SPAWN.y / 2, AREA_WHERE_MINES_SPAWN.y / 2)
	mineObj.position = Vector3 (x, HEIGHT_FROM_ORIGIN, y)
	add_child (mineObj)
