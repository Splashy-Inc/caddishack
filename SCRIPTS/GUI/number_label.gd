extends Label

class_name NumberLabel

signal change_complete

@export var shake_strength := 5.0

@onready var change_up_sound: AudioStreamPlayer = $ChangeUpSound
@onready var change_down_sound: AudioStreamPlayer = $ChangeDownSound

var number_target := 0
var time_to_target = 2.0
var number := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_number(number)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if time_to_target > 0:
		if abs(number - number_target) > 0:
			if number < number_target:
				number = ceil(lerp(number, number_target, time_to_target * delta))
				change_up_sound.play()
			else:
				number = floor(lerp(number, number_target, time_to_target * delta))
				change_down_sound.play()
			text = str(number)
			offset_transform_position = Shaker2D.get_random_position_offset(shake_strength)
		else:
			set_number(number_target)
			change_complete.emit()
			offset_transform_position = Vector2.ZERO

func set_number(new_number : int, time : float = 0.0):
	time_to_target = time
	if time_to_target > 0:
		number_target = new_number
	else:
		number = new_number
		text = str(number)
