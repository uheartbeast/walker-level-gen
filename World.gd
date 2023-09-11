extends Node2D

const Player = preload("res://Player.tscn")
const Exit = preload("res://ExitDoor.tscn")

var borders = Rect2(1, 1, 38, 21)

@onready var tileMap = $TileMap

func _ready():
	randomize()
	generate_level()

func generate_level():
	var walker = Walker.new(Vector2(19, 11), borders)
	var map = walker.walk(200)
	
	var player = Player.instantiate()
	add_child(player)
	player.position = map.front()*32
	
	var exit = Exit.instantiate()
	add_child(exit)
	exit.position = walker.get_end_room().position*32
	exit.connect("leaving_level", Callable(self, "reload_level"))
	
	walker.queue_free()
	var tile_set:TileSet = $TileMap.get_tileset()
	var id = tile_set.get_source_id(0)
	for location in map:
		tileMap.set_cell(0, location, id, Vector2i(0, 0), 0)
	#Equivalent command for setting cells bitmask but not working ATM as terrains need to be setup
	#tileMap.set_cells_terrain_connect(0, map, 0, 0)

func reload_level():
	get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		reload_level()
