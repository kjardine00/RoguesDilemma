extends Camera2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.room_entered.connect(func(room_camera_limit):

		limit_left = room_camera_limit[0]
		limit_top = room_camera_limit[1]
		limit_right = room_camera_limit[2]
		limit_bottom = room_camera_limit[3]
	)
