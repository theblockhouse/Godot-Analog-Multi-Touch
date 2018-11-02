extends CanvasLayer

const RADIUS_ALLOWANCE = 110
const PADDING = 110
const SCREEN_SIZE = Vector2(1024,600)

var RADIUS = 0
var SMALL_RADIUS = 0

var stick1_pos = Vector2()
var stick2_pos = Vector2()
var stick1_vect = Vector2()
var stick2_vect = Vector2()
var stick1_speed = 0.0
var stick2_speed = 0.0
var stick1_angle = Vector2()
var stick2_angle = Vector2()

var left_analog_small = null
var right_analog_small = null

func _ready():
	left_analog_small = $Left_Stick.get_node('Analog_Small')
	right_analog_small = $Right_Stick.get_node('Analog_Small')
	left_analog_small.global_position.x = PADDING
	left_analog_small.global_position.y = SCREEN_SIZE.y - PADDING
	right_analog_small.global_position.x = SCREEN_SIZE.x - PADDING
	right_analog_small.global_position.y = SCREEN_SIZE.y - PADDING
	$Left_Stick/Analog_Big.global_position = left_analog_small.global_position
	$Right_Stick/Analog_Big.global_position = right_analog_small.global_position
	RADIUS = $Left_Stick.get_node('Analog_Big').texture.get_height() / 2
	SMALL_RADIUS = int((left_analog_small.texture.get_height() / 2)  * left_analog_small.transform.get_scale().x)
	stick1_pos = left_analog_small.global_position
	stick2_pos = right_analog_small.global_position
	
func _input(event):
	if (event is InputEventMouseButton and event.is_action_released('left_click') or (event is InputEventScreenTouch and !event.is_pressed())):
		if left_stick_closest(event):
			reset_left_stick()
		else:
			reset_right_stick()

	if event is InputEventScreenDrag and event.index >= 0:
		move_sticks(event)
			
func left_stick_closest(event):
	return left_analog_small.global_position.distance_to(event.position) < right_analog_small.global_position.distance_to(event.position)
			
func reset_left_stick():
	left_analog_small.position = Vector2()
	stick1_vect = Vector2()
	
func reset_right_stick():
	right_analog_small.position = Vector2()
	stick2_vect = Vector2()
	
func move_sticks(event):
	if stick1_pos.distance_to(event.position) < RADIUS + RADIUS_ALLOWANCE:
		var left_event_pos = event.position
		move_small_stick(left_event_pos, stick1_pos, 0)
		
	if stick2_pos.distance_to(event.position) < RADIUS + RADIUS_ALLOWANCE:
		var right_event_pos = event.position
		move_small_stick(right_event_pos, stick2_pos, 1)
		
func move_small_stick(event_pos, stick_pos, stick):
	var dist = stick_pos.distance_to(event_pos)
    
	if dist + SMALL_RADIUS > RADIUS:
		dist = RADIUS - SMALL_RADIUS
		
	var vect = (event_pos - stick_pos).normalized()
	var angle = event_pos.angle_to_point(stick_pos)

	stick1_vect = vect
	stick1_speed = dist
	stick1_angle = angle
	
	if stick:
		right_analog_small.position = vect * dist
	else:
		left_analog_small.position = vect * dist
	