extends CanvasLayer

func _on_RollButton_pressed():
	get_tree().root.get_node('Game').get_node('my_player').roll()

func disable_joysticks():
	$Joystick_Left.set_process_input(false)
	$Joystick_Right.set_process_input(false)
	$Joystick_Left.reset_joystick()
	$Joystick_Right.reset_joystick()
	
func enable_joysticks():
	$Joystick_Left.set_process_input(true)
	$Joystick_Right.set_process_input(true)