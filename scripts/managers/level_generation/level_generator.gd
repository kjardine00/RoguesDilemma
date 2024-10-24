extends Node2D

var rooms = []
var rooms_positions = []

@export var number_of_rooms = 10

@export var start_room: PackedScene
@export var normal_rooms: Array[PackedScene]

var room_size: Vector2 = Vector2(352, 208)

var borders:= Rect2(1, 1, 20, 20)
var starting_room_pos

@onready var level: Node2D = $Rooms
@onready var num_of_rooms_lbl: Label = $CanvasLayer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	number_of_rooms = GameManager.number_of_rooms
	call_deferred("generate_level")
	num_of_rooms_lbl.text = "NUMBER OF ROOMS: " + str(number_of_rooms)
	starting_room_pos = borders.size / 2
	
	# Gets the correct size of the rooms
	if normal_rooms.size() != 0:
		var inst = normal_rooms[0].instantiate()
		for i in inst.get_children():
			if i is TileMap:
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
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_plus_btn_pressed() -> void:
	GameManager.number_of_rooms += 1
	num_of_rooms_lbl.text = "NUMBER OF ROOMS: " + str(GameManager.number_of_rooms)

func _on_minus_btn_pressed() -> void:
	GameManager.number_of_rooms -= 1
	num_of_rooms_lbl.text = "NUMBER OF ROOMS: " + str(GameManager.number_of_rooms)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()

func _on_gen_btn_pressed() -> void:
	pass # Replace with function body.
