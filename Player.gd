extends CharacterBody2D

func _physics_process(_delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	set_velocity(Vector2(x_input, y_input)*100)
	move_and_slide()
