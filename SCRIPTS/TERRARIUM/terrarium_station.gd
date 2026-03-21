extends Station

class_name TerrariumStation

@export var material_scene : PackedScene

@onready var terrarium: Terrarium = $PlayScreen/PlayingField/Terrarium
@onready var playing_field: Node = $PlayScreen/PlayingField


func _station_ready():
	pass
