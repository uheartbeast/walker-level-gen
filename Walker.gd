extends Node
class_name Walker


const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var rooms = []
var step_history = []
var steps_since_turn = 0


func _init(starting_position,new_borders):
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	borders = new_borders

	
func walk(steps):
	place_room(position)
	for step_r in steps:
		if randf() <= 0.6 and steps_since_turn >= 6:change_direction()
		
		if step():
			#Make it so no repeat steps
			#if !step_history.has(position):
			step_history.append(position)
		else:change_direction()
	return step_history
	
	
func step():
	var target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	else:return false


func change_direction():
	place_room(position)
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while !borders.has_point(position + direction):
		direction = directions.pop_front()


func place_room(place_position):
	var size = Vector2(randi() % 4 + 2, randi() % 4 + 2)
	var top_left_corner = Vector2(place_position - size / 2).ceil()
	var room_index = rooms.size()
	rooms.append(create_room(position, size))
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)


func create_room(room_position, room_size):
	return {position = room_position, size = room_size}
	

func get_end_room():
	var end_room = rooms.pop_front()
	var starting_position = step_history.front()
	for room in rooms:
		if starting_position.distance_to(room.position) > starting_position.distance_to(end_room.position):
			end_room = room
	return end_room
