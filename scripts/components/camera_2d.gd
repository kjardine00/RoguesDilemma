extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = GameManager.camera_position
	zoom = GameManager.camera_zoom

func _input(event: InputEvent) -> void:
	if event.get_action_strength("mouse_up"):
		zoom = clamp(zoom + Vector2.ONE * 0.01 ,Vector2.ONE * 0.1,Vector2.ONE * 5.0)

	if event.get_action_strength("mouse_down"):
		zoom = clamp(zoom - Vector2.ONE * 0.01 ,Vector2.ONE * 0.1,Vector2.ONE * 5.0)
	
	if event is InputEventMouseMotion and Input.is_action_pressed("MLB"):
		global_position -= event.relative / zoom
