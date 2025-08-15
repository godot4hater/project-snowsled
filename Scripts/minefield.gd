extends Node3D

var mineScene: PackedScene 				= preload ("res://Scenes/mine.tscn")
const AREA_WHERE_MINES_SPAWN : Vector2 	= Vector2 (36, 36)
const HEIGHT_FROM_ORIGIN : float 		= 30.0
const RANDOM_SECONDS_RANGE : Vector2 		= Vector2 (6.85, 16.0)

func _ready() -> void:
	WaitForTree()

func WaitForTree() -> void:
	await get_tree().create_timer (randf_range (RANDOM_SECONDS_RANGE.x, RANDOM_SECONDS_RANGE.y)).timeout
	SpawnMine()
	WaitForTree()

func SpawnMine() -> void:
	var mineObj = mineScene.instantiate()
	var x = randf_range (-AREA_WHERE_MINES_SPAWN.x / 2, AREA_WHERE_MINES_SPAWN.x / 2)
	var y = randf_range (-AREA_WHERE_MINES_SPAWN.y / 2, AREA_WHERE_MINES_SPAWN.y / 2)
	mineObj.position = Vector3 (x, HEIGHT_FROM_ORIGIN, y)
	add_child (mineObj)
