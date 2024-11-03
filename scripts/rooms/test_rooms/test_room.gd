extends Node2D
class_name Room

@export var room_size: Vector2 = Vector2(352, 208)

var room_camera_limit

@onready var top_left_border: Marker2D = $TopLeftBorder
@onready var bottom_right_border: Marker2D = $BottomRightBorder

#TODO Adjust the marker2ds to allow the player to more smoothly tranisition between rooms

func _on_player_detector_body_entered(body: Node2D) -> void:
	var room_camera_limit = [top_left_border.global_position.x, top_left_border.global_position.y, bottom_right_border.global_position.x, bottom_right_border.global_position.y]
	Events.room_entered.emit(room_camera_limit, )
