extends Label

class_name NumberLabel

signal change_complete

@onready var change_sound: AudioStreamPlayer = $ChangeSound

var number_target = 0.0
var time_to_target = 2.0
var number = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_number(number)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if time_to_target > 0:
		if number < number_target:
			var change = clamp(int(number_target / time_to_target * delta), 1, number_target)
			number += change
			text = str(number)
			change_sound.play()
		else:
			set_number(number_target)
			change_complete.emit()

func set_number(new_number : int, time : float = 0.0):
	time_to_target = time
	if time_to_target > 0:
		number_target = new_number
	else:
		number = new_number
		text = str(number)
		
