extends Node2D

# Walker generated room positions
var rooms = []
var rooms_positions = []
# Position of end rooms
var end_rooms = []

@export var number_of_rooms = 10
@export var number_of_treasure_rooms = 1

@export var start_room: PackedScene
@export var boss_rooms: Array[PackedScene]
@export var normal_rooms: Array[PackedScene]
@export var treasure_rooms: Array[PackedScene]

var room_size: Vector2 = Vector2(352, 208)

var borders:= Rect2(1, 1, 20, 20)
@export var starting_room_pos = Vector2()

@onready var level: Node2D = $Rooms
@onready var num_of_rooms_lbl: Label = $CanvasLayer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	number_of_rooms = GameManager.number_of_rooms
	call_deferred("generate_level")
	num_of_rooms_lbl.text = "NUMBER OF ROOMS: " + str(number_of_rooms)
	
	# Gets the correct size of the rooms
	if normal_rooms.size() != 0:
		var inst = normal_rooms[0].instantiate()
		for i in inst.get_children():
			if i is TileMapLayer:
				room_size = i.get_used_rect().size * i.tile_set.tile_size
		inst.queue_free()
	else:
		printerr("NO NORMAL ROOMS FOUND")
	

func generate_level():
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	#TODO remove after builing lvl gen, need to decide on the initial level builds and don't need the control in an interface
	if number_of_rooms < 7:
		number_of_rooms = 10
		num_of_rooms_lbl.text = "NUMBER OF ROOMS: " + str(number_of_rooms)
	
	#randomizes the range of number of rooms per generation
	number_of_rooms = randi_range(number_of_rooms / 1.1, number_of_rooms * 1.2)
	var min_num_dead_ends = ceil(number_of_rooms / 3.0) + 1
	
	if min_num_dead_ends > 15:
		min_num_dead_ends = 15
	
	# Start Generation attempt by clearing current set of rooms and run the walker
	while end_rooms.size() < min_num_dead_ends or end_rooms.has(starting_room_pos):
		print("NEW GENERATION ATTEMPT")
		rooms.clear()
		end_rooms.clear()
		var walker = Walker.new(starting_room_pos, borders)
		rooms = walker.walk(number_of_rooms)
		end_rooms = walker.get_end_rooms()
		walker.call_deferred("queue_free")
	
	# Uses the walker step history to make coords for room placement
	rooms_positions = rooms.duplicate()
	
	if start_room != null:
		place_starting_room()
	else:
		printerr("NO STARTING ROOM FOUND")
		
	if boss_rooms.size() != 0:
		place_boss_room()
	else:
		printerr("NO BOSS ROOM FOUND")
	
	if treasure_rooms.size() != 0:
		for i in number_of_treasure_rooms:
			place_treasure_room()
	else:
		printerr("NO TREASURE ROOM FOUND")
	
	if normal_rooms.size() != 0:
		for location in rooms:
			var inst = normal_rooms.pick_random().instantiate()
			level.call_deferred("add_child", inst)
			inst.position = location * room_size
	else:
		printerr("NO NORMAL ROOMS FOUND")

func place_starting_room():
	var inst = start_room.instantiate()
	level.call_deferred("add_child", inst)
	
	## STARTING ROOM ALWAYS IN THE SAME POSITION
	
	inst.position = starting_room_pos * room_size
	rooms.erase(starting_room_pos)
	
	## STARTING ROOM IN DIFFERENT POSITION EVERY TIME
	
	#starting_room_pos = rooms.pick_random()
	#while end_rooms.has(starting_room_pos):
		#starting_room_pos = rooms.pick_random()
	#
	#inst.position = starting_room_pos * room_size
	#
	#rooms.erase(starting_room_pos)

func place_boss_room():
	var boss_room_location = starting_room_pos
	for i in end_rooms:
		var distance_to_end_room = starting_room_pos.distance_to(i)
		var distance_to_boss_room = starting_room_pos.distance_to(boss_room_location)
		if distance_to_end_room > distance_to_boss_room:
			boss_room_location = i
	
	var inst = boss_rooms.pick_random().instantiate()
	level.call_deferred("add_child", inst)
	inst.position = boss_room_location * room_size
	
	rooms.erase(boss_room_location)
	end_rooms.erase(boss_room_location)
	
func place_treasure_room():
	var treasure_room_location = end_rooms[randi_range(0, end_rooms.size() - 1)]
	
	var inst = treasure_rooms.pick_random().instantiate()
	level.call_deferred("add_child", inst)
	inst.position = treasure_room_location * room_size
	
	rooms.erase(treasure_room_location)
	end_rooms.erase(treasure_room_location)

func _on_plus_btn_pressed() -> void:
	GameManager.number_of_rooms += 1
	num_of_rooms_lbl.text = "NUMBER OF ROOMS: " + str(GameManager.number_of_rooms)

func _on_minus_btn_pressed() -> void:
	GameManager.number_of_rooms -= 1
	num_of_rooms_lbl.text = "NUMBER OF ROOMS: " + str(GameManager.number_of_rooms)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()

func _on_gen_btn_pressed():
	pass
	
	get_tree().reload_current_scene()
