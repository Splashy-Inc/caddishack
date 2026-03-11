extends Node2D

class_name ItemInfoBox

@export var info_row_scene: PackedScene

@export var item_info : ItemInfo

@onready var item_info_list: VBoxContainer = $ShiftContainer/ItemInfoList
@onready var name_label: Label = $ShiftContainer/ItemInfoList/Name
@onready var description: Label = $ShiftContainer/ItemInfoList/Description

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible:
		global_rotation = 0
		global_scale = Vector2(1.0, 1.0)
		global_position = get_viewport().get_mouse_position()

func set_item_info(new_item_info: ItemInfo):
	item_info = new_item_info

func populate_info():
	name_label.text = item_info.name
	description.text = item_info.description
	
	for row in item_info_list.get_children():
		if row is ItemInfoRow:
			row.queue_free()
	
	for i in item_info.labels.size():
		var new_info_row = info_row_scene.instantiate()
		new_info_row.set_label(item_info.labels[i])
		
		if i < item_info.values.size():
			new_info_row.set_value(item_info.values[i])
		
		item_info_list.add_child(new_info_row)

func show_self():
	populate_info()
	visible = true
