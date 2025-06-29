extends PanelContainer

class_name CartPanel

signal checkout_pressed(materials: Array[MaterialInfo], current_money: int)
signal checkout_failed

@export var materials : Array[MaterialInfo]
@export var current_money := 0

@onready var total_cost_label: Label = $VBoxContainer/CurrentCostRow/Value
@onready var material_grid: GridContainer = $VBoxContainer/MaterialGrid
@onready var current_money_label: Label = $VBoxContainer/CurrentMoneyRow/Value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for material_count in material_grid.get_children():
		if material_count is CartMaterialCount:
			material_count.item_pressed.connect(_on_cart_item_pressed)
	
	set_current_money(current_money)
	reset_cart()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_material(new_material_info: MaterialInfo):
	if not new_material_info in materials:
		materials.append(new_material_info)
	update_materials_display()

func set_materials(materials_info: Array[MaterialInfo]):
	clear_cart()
	for material_info in materials_info:
		add_material(material_info)

func remove_material(material: MaterialInfo):
	materials.erase(material)
	update_materials_display()

func calculate_cost() -> int:
	var total_cost := 0
	for material in materials:
		total_cost += material.price
	total_cost_label.text = str(total_cost)
	return total_cost

func reset_cart():
	materials.clear()
	for i in clamp(10 - Globals.run_info.bead_pile.get_beads().size(), 0, 10) - get_eggs(materials).size():
		materials.append(EggMaterialInfo.new())
	update_materials_display()

func clear_cart():
	materials.clear()
	update_materials_display()

func _on_checkout_button_pressed() -> void:
	var cost := calculate_cost()
	if cost <= current_money and get_eggs(materials).size() >= 10 - Globals.run_info.bead_pile.get_beads().size():
		set_current_money(current_money - cost)
		checkout_pressed.emit(materials, current_money)
		reset_cart()
	else:
		checkout_failed.emit()

func _on_cart_item_pressed(material_info: MaterialInfo):
	var material_to_remove : MaterialInfo
	for material in materials:
		if check_material_match(material, material_info):
			remove_material(material)
			return

func update_materials_display():
	var material_counts = material_grid.get_children()
	for material_count in material_counts:
		if not material_count.is_node_ready():
			await material_count.ready
		if material_count is CartMaterialCount:
			var material_total := 0
			for material in materials:
				if check_material_match(material_count.material_info, material):
					material_total += 1
			material_count.set_count(material_total)
	calculate_cost()

func check_material_match(material_info_1: MaterialInfo, material_info_2: MaterialInfo):
	if material_info_1 is SandMaterialInfo and material_info_2 is SandMaterialInfo:
		if material_info_1.color == material_info_2.color:
			return true
	elif material_info_1 is SpecialMaterialInfo and material_info_2 is SpecialMaterialInfo:
		if material_info_1.type == material_info_2.type:
			return true
	elif material_info_1 is EggMaterialInfo and material_info_2 is EggMaterialInfo:
		if material_info_1.type == material_info_2.type:
			return true
	return false

func set_current_money(new_money: int):
	current_money = new_money
	current_money_label.text = str(current_money)

func get_eggs(materials: Array[MaterialInfo]) -> Array[EggMaterialInfo]:
	var eggs : Array[EggMaterialInfo]
	for material in materials:
		if material is EggMaterialInfo:
			eggs.append(material)
	
	return eggs
