extends Resource

class_name BraceletInfo

@export var bead_array_info : BeadArrayInfo
var points := 0
var mult := 1
var value := 0

var color_chains : Array[Array]
var special_chains : Array[Array]

func update_points(new_points: int, is_overwrite: bool = false):
	if is_overwrite:
		points = new_points
	else:
		points += new_points
	
	value = get_value()

func update_mult(new_mult: int, is_overwrite: bool = false):
	if is_overwrite:
		mult = new_mult
	else:
		mult += new_mult
	
	value = get_value()

func get_value():
	return points * mult
