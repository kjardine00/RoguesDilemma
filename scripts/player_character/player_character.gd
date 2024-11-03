extends CharacterBody2D
class_name PlayerCharacter

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var char_direction

func _physics_process(delta: float) -> void:
	# Add the gravity.
# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction:L -1, 0, R 1
	char_direction = Input.get_axis("player_move_left", "player_move_right")

	# Play Idle and Run Animations
	if is_on_floor():
		if char_direction == 0: 
			##TODO Insert character Idle anim
			pass
		else:
			##TODO Insert character Walk/Run anims
			pass

#	TODO orient the animated sprite to the correct direction
	if char_direction > 0:
		pass
	elif char_direction < 0:
		pass

	#Apply movement
	if char_direction:
		velocity.x = char_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Handle jump.
	if Input.is_action_just_pressed("player_move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		#TODO Inset player jump animation
