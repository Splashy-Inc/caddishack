extends Node

signal info_updated

const ordered_stations := [
	preload("res://SCENES/SHOP/shop_station.tscn"),
	preload("res://SCENES/TERRARIUM/terrarium_station.tscn"),
	preload("res://SCENES/CRAFT_STATION/bracelet_station.tscn"),
]

var cur_station_scene: PackedScene

var joypad_connected := false

var joystick: JoyStick

var is_mobile = false

var info = 10 # Example info to track for level UI

var run_info := RunInfo.new()

const material_scenes = {
	"sand": preload("res://SCENES/SHOP/sand_material.tscn"),
	"pearl": preload("res://SCENES/SHOP/pearl_material.tscn"),
	"shell": preload("res://SCENES/SHOP/shell_material.tscn"),
	"jimmie": preload("res://SCENES/SHOP/jimmie_material.tscn"),
	"egg": preload("res://SCENES/SHOP/egg_material.tscn"),
}

const larva_scene := preload("res://SCENES/TERRARIUM/caddisfly.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	joypad_connected = Input.get_connected_joypads().size() > 0
	
	if OS.has_feature("mobile") or OS.has_feature("web_android") or OS.has_feature("web_ios"):
		is_mobile = true
	
	reset_run()

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
	elif material_info is EggMaterialInfo:
		new_material = material_scenes["egg"].instantiate()
	
	new_material.info = material_info
	return new_material

func generate_larva() -> CaddisFly:
	return larva_scene.instantiate()

func reset_run():
	run_info = load("res://RESOURCES/test_run.tres").duplicate(true)

func change_run_money(amount: int):
	run_info.money += amount
