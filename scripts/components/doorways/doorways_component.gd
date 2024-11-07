extends Node2D
class_name Doorways

@export_category("Open Doorways")
@export var left : bool
@export var up : bool
@export var right : bool
@export var down : bool

@export_category("Properties")
@export var left_right_size = Vector2(16, 48)
@export var up_down_size = Vector2(64, 16)

@onready var player_detector_collision: CollisionShape2D = $PlayerDetector/PlayerDetectorCollision

@onready var left_marker: Marker2D = $Left/LeftMarker
@onready var up_marker: Marker2D = $Up/UpMarker
@onready var right_marker: Marker2D = $Right/RightMarker
@onready var down_marker: Marker2D = $Down/DownMarker

@onready var left_collision: CollisionShape2D = $Left/LeftCollision
@onready var up_collision: CollisionShape2D = $Up/UpCollision
@onready var right_collision: CollisionShape2D = $Right/RightCollision
@onready var down_collision: CollisionShape2D = $Down/DownCollision

var room_size

# Setup Player Detector Collision
func setup_doorway_collision(rs):
	room_size = rs
	player_detector_collision.position = room_size / 2
	if room_size:
		player_detector_collision.shape.size = room_size - (2 * Vector2(32, 32))
	
	# Setup Doorway Collision Boxes and Doorway Detectors
	left_collision.disabled = true
	up_collision.disabled = true
	right_collision.disabled = true
	down_collision.disabled = true
	
	var x_marker_distance = 48
	var up_marker_distance = 48
	var down_marker_distance = 48
	
	if left:
		left_collision.disabled = false
		left_collision.shape.size = left_right_size
		left_collision.position = Vector2(12, room_size.y - 56)
		left_marker.position = left_collision.position - Vector2(x_marker_distance, 0)
	if up:
		up_collision.disabled = false
		up_collision.shape.size = up_down_size
		up_collision.position = Vector2(room_size.x / 2, 16)
		up_marker.position = up_collision.position - Vector2(0, up_marker_distance)
	if right:
		right_collision.disabled = false
		right_collision.shape.size = left_right_size
		right_collision.position = Vector2(room_size.x - 8, room_size.y - 56)
		right_marker.position = right_collision.position + Vector2(x_marker_distance, 0)
	if down:
		down_collision.disabled = false
		down_collision.shape.size = up_down_size
		down_collision.position = Vector2(room_size.x / 2, room_size.y - 16)
		down_marker.position = down_collision.position + Vector2(0, down_marker_distance)


func _on_left_body_entered(body: Node2D) -> void:
	body.global_position = left_marker.global_position


func _on_up_body_entered(body: Node2D) -> void:
	body.global_position = up_marker.global_position


func _on_right_body_entered(body: Node2D) -> void:
	body.global_position = right_marker.global_position


func _on_down_body_entered(body: Node2D) -> void:
	body.global_position = down_marker.global_position


func _on_player_detector_body_entered(_body: Node2D) -> void:
	#TODO Find a better way to transition rooms so it is smoother
	## This sends the room borders to the camera to set camera limit 
	var left_border = self.global_position.x
	var top_border = self.global_position.y
	var right_border = self.global_position.x + room_size.x
	var down_border = self.global_position.y + room_size.y

	var room_borders = [left_border, top_border, right_border, down_border]
	print("room borders " + str(room_borders))
	Events.room_entered.emit(room_borders)
