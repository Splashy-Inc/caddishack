extends Station

class_name ShopStation

@export var terrariums : Array[Terrarium]
@export var terrarium_buttons : Array[Button]
@onready var next_button: Button = $PanelContainer/HBoxContainer/UISection/NextButton
@export var terrarium_zoom_point: ZoomPoint
@onready var terrarium_select: PanelContainer = $TerrariumSelect
@onready var terrarium_select_button: SelectButton = $TerrariumSelect/HBoxContainer/SelectButton
@export var item_slots : Array[PanelContainer]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_reroll_button_pressed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_next_button_pressed() -> void:
	for button in terrarium_buttons:
		if button.button_pressed:
			RunEvents.set_current_terrarium_info(terrariums[terrarium_buttons.find(button)].info)
	ScreenEvents.request_screen(ScreenEvents.Screen.TERRARIUM)

func randomize_terrariums():
	for terrarium in terrariums:
		terrarium.randomize_materials()

func randomize_abilities():
	for slot in item_slots:
		if not slot.get_children().is_empty():
			for child in slot.get_children():
				child.free()
		var new_item = Globals.generate_shop_item(RunEvents.get_abilities().pick_random())
		new_item.pressed.connect(_on_item_chosen.bind(new_item.info))
		slot.add_child(new_item)
	for terrarium in terrariums:
		terrarium.randomize_materials()

func _on_reroll_button_pressed() -> void:
	for button in terrarium_buttons:
		var terrarium = terrariums[terrarium_buttons.find(button)]
		terrarium.toggle_travel(true)
		terrarium_zoom_point.dezoom_node(terrarium)
		button.button_pressed = false
		button.toggle_mode = false
	next_button.disabled = true
	randomize_abilities()
	randomize_terrariums()

func _on_terrarium_button_pressed(source_button: Button) -> void:
	for button in terrarium_buttons:
		var terrarium = terrariums[terrarium_buttons.find(button)]
		if button != source_button:
			terrarium.toggle_travel(true)
			terrarium_zoom_point.dezoom_node(terrarium)
		else:
			button.button_pressed = true
			terrarium_select.show()
			terrarium.toggle_travel(false)
			terrarium_zoom_point.zoom_node(terrarium)
			terrarium_select_button.set_select_target(terrarium)

func _on_terrarium_select_button_pressed() -> void:
	terrarium_select.hide()
	next_button.disabled = false
	for button in terrarium_buttons:
		var terrarium = terrariums[terrarium_buttons.find(button)]
		terrarium.toggle_travel(true)
		terrarium_zoom_point.dezoom_node(terrarium)
		if terrarium != terrarium_select_button.get_select_target():
			button.button_pressed = false
			button.toggle_mode = false
		else:
			button.toggle_mode = true
			button.button_pressed = true

func _on_terrarium_back_button_pressed() -> void:
	terrarium_select.hide()
	for button in terrarium_buttons:
		var terrarium = terrariums[terrarium_buttons.find(button)]
		terrarium.toggle_travel(true)
		terrarium_zoom_point.dezoom_node(terrarium)

func _on_item_chosen(item_info : ShopItemInfo):
	if item_info is ShopAbilityInfo:
		ScreenEvents.request_screen(ScreenEvents.Screen.DECK, item_info)
	else:
		ShopEvents.purchase_item(item_info)
