extends Node3D

var mineScene: PackedScene 				= preload ("res://Scenes/mine.tscn")
const areaWhereMinesSpawn : Vector2 	= Vector2 (35, 35)
const heightFromOrigin : float 			= 30.0
const randSecondsRange : Vector2 		= Vector2 (7.0, 15.0)

func _ready() -> void:
	WaitForTree()

func WaitForTree() -> void:
	await get_tree().create_timer (randf_range (randSecondsRange.x, randSecondsRange.y)).timeout
	SpawnMine()
	WaitForTree()

func SpawnMine() -> void:
	var mineObj = mineScene.instantiate()
	var x = randf_range (-areaWhereMinesSpawn.x / 2, areaWhereMinesSpawn.x / 2)
	var y = randf_range (-areaWhereMinesSpawn.y / 2, areaWhereMinesSpawn.y / 2)
	mineObj.position = Vector3 (x, heightFromOrigin, y)
	add_child (mineObj)
