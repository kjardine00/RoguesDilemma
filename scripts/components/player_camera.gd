extends Camera2D

@export var camera_border_limit = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.room_entered.connect(func(room_borders):

		self.limit_left = room_borders[0] - camera_border_limit
		self.limit_top = room_borders[1] - camera_border_limit
		self.limit_right = room_borders[2] - camera_border_limit
		self.limit_bottom = room_borders[3] - camera_border_limit
	)
