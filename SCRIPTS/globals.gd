extends Node

signal info_updated

const ordered_stations := [
	preload("res://SCENES/SHOP/shop_station.tscn"),
	preload("res://SCENES/TERRARIUM/terrarium_station.tscn"),
]
const larva_scene := preload("uid://bavo2v0il8e4")
const larva_card_scene := preload("uid://cue2ptvqn6f3r")

var cur_station_scene: PackedScene

var joypad_connected := false

var is_mobile = false

var info = 10 # Example info to track for level UI

const material_scenes = {
	"sand": preload("res://SCENES/MATERIALS/sand_material.tscn"),
	"pearl": preload("res://SCENES/MATERIALS/pearl_material.tscn"),
	"shell": preload("res://SCENES/MATERIALS/shell_material.tscn"),
	"jimmie": preload("res://SCENES/MATERIALS/jimmie_material.tscn"),
	"heart": preload("res://SCENES/MATERIALS/heart_material.tscn"),
	"spade": preload("res://SCENES/MATERIALS/spade_material.tscn"),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	joypad_connected = Input.get_connected_joypads().size() > 0
	
	if OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios"):
		is_mobile = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_joy_connection_changed(device, connected):
	joypad_connected = Input.get_connected_joypads().size() > 0

func update_info(new_info):
	info = new_info
	info_updated.emit(info)

func generate_material(material_info: MaterialInfo) -> BeadMaterial:
	var new_material: BeadMaterial
	if material_info is SandMaterialInfo:
		new_material = material_scenes["sand"].instantiate()
	elif material_info is SpecialMaterialInfo:
		match material_info.type:
			SpecialMaterialInfo.SpecialType.PEARL:
				new_material = material_scenes["pearl"].instantiate()
			SpecialMaterialInfo.SpecialType.SHELL:
				new_material = material_scenes["shell"].instantiate()
			SpecialMaterialInfo.SpecialType.JIMMIE:
				new_material = material_scenes["jimmie"].instantiate()
			SpecialMaterialInfo.SpecialType.HEART:
				new_material = material_scenes["heart"].instantiate()
			SpecialMaterialInfo.SpecialType.SPADE:
				new_material = material_scenes["spade"].instantiate()
	
	new_material.info = material_info
	return new_material

func generate_card(larva_info: LarvaInfo = null) -> LarvaCard:
	var new_card := larva_card_scene.instantiate() as LarvaCard
	
	if is_instance_valid(larva_info):
		new_card.load_from_larva_info(larva_info)
	
	return new_card
