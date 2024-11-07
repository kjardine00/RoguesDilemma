extends Node2D

@onready var player: PlayerCharacter = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.spawn_player.connect(func(spawn_pos):
		player.global_position = spawn_pos
		)
