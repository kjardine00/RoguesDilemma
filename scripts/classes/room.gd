extends Node2D
class_name Room

@export_category("Setup Components")
@export var tilemaplayer : TileMapLayer
@export var doorways : Doorways
@export var spawn : Marker2D

@export_category("Properties")
#TODO Add other room types like SECRET, REWARD, ETC
enum ROOM_TYPE{START, NORMAL, TREASURE, BOSS}
@export var room_type : ROOM_TYPE

@export_category("Room Connections")
@export var left : bool
@export var up : bool
@export var right : bool
@export var down : bool

var room_size: Vector2

var room_camera_limit

func _ready() -> void:
	if tilemaplayer:
		room_size = tilemaplayer.get_used_rect().size * tilemaplayer.tile_set.tile_size
	else:
		printerr("CONNECT TILEMAPLAYER TO " + str(self))

	if doorways:
		doorways.setup_doorway_collision(room_size)
	else:
		printerr("CONNECT DOORWAYS COMPONENT TO " + str(self))
	
	if spawn:
		Events.spawn_player.emit(spawn.global_position)
