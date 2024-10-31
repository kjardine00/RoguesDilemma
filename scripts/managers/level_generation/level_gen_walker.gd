extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var step_history = []
var borders = Rect2()
var direction = Vector2.RIGHT
var target_position = Vector2.ZERO
var steps_since_turn = 0

func _init(starting_position, new_borders) -> void:
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	borders = new_borders
	direction = DIRECTIONS[randi() % 4]

# Run the Walker through each step and return the coords of the room positions
func walk(steps):
	var step_count = 0
	while(step_count < steps - 1):
		
		#TODO make this an export var
		var max_hallway_length = ceil(steps / 3.0)
		
		if max_hallway_length < 4:
			max_hallway_length = 4
		
		#TODO Check if I need to change this hard coded 2
		if steps_since_turn >= 2:
			change_direction()
		
		# If step is on the border of allotted space then check other conditions if n
		if step():
			
			# If the walker has already been to this position
			if step_history.has(target_position) == true:
				position = target_position
				change_direction()
				continue
			var neighbours = ncount(target_position)
			
			# If this step has neighbors greater than 1
			if neighbours > 1:
				change_direction()
				continue
				
			# Randomize direction change
			if randf() < 0.5:
				change_direction()
				continue
			
			# Check how long the steps has moved in the same direction
			if get_hallway_length(target_position) > max_hallway_length:
				change_direction()
				continue
			
			# Set current potential step to the position we will save
			position = target_position
			
			# Save position in history
			step_history.append(position)
			step_count += 1
		else:
			change_direction()
	
	return step_history

# Check all the rooms in the room history and return the rooms that dont have neighboors thus being an end room
func get_end_rooms():
	var end_rooms = []
	for step_position in step_history:
		if ncount(step_position) == 1:
			end_rooms.append(step_position)
			
	return end_rooms

# Checks if step is at the border of the level
func step():
	target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		return true
	else:
		return false
		
# Reset steps since turn, remove direction the walker was moving in and then shuffle the remainder and pick one
func change_direction():
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	#TODO needed?
	while not borders.has_point(position + direction):
		direction = directions.pop_front()
	
func ncount(pos):
	return int(step_history.has(pos + Vector2.LEFT)) \
	+ int(step_history.has(pos + Vector2.UP)) \
	+ int(step_history.has(pos + Vector2.RIGHT)) \
	+ int(step_history.has(pos + Vector2.DOWN))
	
func get_hallway_length(pos):
	var longest_hallway = 0
	var hallway_length = 0
	
	# Check right hallway
	hallway_length = calc_hallway_length(pos, Vector2.RIGHT)
	longest_hallway = get_longest_hallway(longest_hallway, hallway_length)
	# Check left hallway
	hallway_length = calc_hallway_length(pos, Vector2.LEFT)
	longest_hallway = get_longest_hallway(longest_hallway, hallway_length)
	# Check up hallway
	hallway_length = calc_hallway_length(pos, Vector2.UP)
	longest_hallway = get_longest_hallway(longest_hallway, hallway_length)
	# Check down hallway
	hallway_length = calc_hallway_length(pos, Vector2.DOWN)
	longest_hallway = get_longest_hallway(longest_hallway, hallway_length)
	
	return longest_hallway

# Take the position of a room and look through step history to see how far a hallway is in every direction
func calc_hallway_length(start_room, hallway_direction):
	var hallway_length = 1
	while(step_history.has(start_room + hallway_direction)):
		start_room += hallway_direction
		hallway_length += 1
	return hallway_length
	
func get_longest_hallway(longest_hallway, current_hallway_length):
	if current_hallway_length > longest_hallway:
		return current_hallway_length
	else:
		return longest_hallway
