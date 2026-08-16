extends Station

class_name ShopStation

@export var info : ShopInfo
@export var terrariums : Array[Terrarium]
@export var terrarium_buttons : Array[Button]
@onready var next_button: Button = $PanelContainer/HBoxContainer/UISection/NextButton
@export var terrarium_zoom_point: ZoomPoint
@onready var terrarium_select: PanelContainer = $TerrariumSelect
@onready var terrarium_select_button: SelectButton = $TerrariumSelect/HBoxContainer/SelectButton
@export var item_slots : Array[PanelContainer]
@onready var reroll_button: Button = $PanelContainer/HBoxContainer/ItemSection/RerollButton
@onready var terrariums_animation_tree: AnimationTree = $PanelContainer/HBoxContainer/TerrariumPanel/Terrariums/AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_instance_valid(info):
		load_from_info(info)
	else:
		randomize_abilities()
		randomize_terrariums()
		sync_info()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_from_info(new_info: ShopInfo):
	if not is_node_ready():
		await ready
	info = new_info.duplicate(true)
	
	# Make sure there aren't more items in the info than can fit in the shop
	if info.items.size() > item_slots.size():
		info.items.resize(item_slots.size())
	
	# Make sure there aren't more terrariums in the info than can fit in the shop
	if info.terrariums.size() > item_slots.size():
		info.terrariums.resize(terrariums.size())
	
	info.selected_terrarium = clamp(info.selected_terrarium, -1, terrariums.size())
	
	# Randomize then fill slots with item from info, or empty slot as avilable
	randomize_abilities()
	for i in item_slots.size():
		if i < info.items.size():
			var slot = item_slots[i]
			if info.items[i] == null: # Allows loading empty slots when purchased
				if not slot.get_children().is_empty():
					for child in slot.get_children():
						child.free()
				continue
			
			# TODO: Add better handling, especially in the case no child exists
			var shop_item = slot.get_child(0)
			if shop_item is ShopItem:
				shop_item.load_info(info.items[i])
	
	# Randomize then fill in terrariums with state from info as avialable
	randomize_terrariums()
	for i in terrariums.size():
		if i < info.terrariums.size():
			if info.terrariums[i] != null:
				terrariums[i].initialize(info.terrariums[i])
	
	# If a terrarium in the info is selected, make sure it's selected on load
	for i in terrarium_buttons.size():
		var button = terrarium_buttons[i]
		if i != info.selected_terrarium:
			button.button_pressed = false
			button.toggle_mode = false
		else:
			button.toggle_mode = true
			button.button_pressed = true
			next_button.disabled = false
	
	sync_info()

func sync_info():
	info.items.clear()
	for slot in item_slots:
		if not slot.get_children().is_empty():
			var item = slot.get_child(0)
			if item is ShopItem:
				info.items.append(item.info)
				continue
		info.items.append(null)
	
	info.terrariums.clear()
	for terrarium in terrariums:
		info.terrariums.append(terrarium.info)
	
	for button in terrarium_buttons:
		if button.button_pressed:
			info.selected_terrarium = terrarium_buttons.find(button)

func _on_next_button_pressed() -> void:
	for button in terrarium_buttons:
		if button.button_pressed:
			RunEvents.set_current_terrarium_info(terrariums[terrarium_buttons.find(button)].info)
	ScreenEvents.request_screen(ScreenEvents.Screen.TERRARIUM)

func randomize_terrariums():
	for button in terrarium_buttons:
		if not button.button_pressed:
			var terrarium = terrariums[terrarium_buttons.find(button)]
			terrarium.randomize_materials()

func randomize_abilities():
	for slot in item_slots:
		if not slot.get_children().is_empty():
			for child in slot.get_children():
				child.free()
		var new_item = Globals.generate_shop_item(RunEvents.get_abilities().pick_random())
		new_item.pressed.connect(_on_item_chosen.bind(new_item))
		slot.add_child(new_item)

func _on_reroll_button_pressed() -> void:
	RunEvents.change_score(-reroll_button.cost)
	randomize_abilities()
	randomize_terrariums()
	sync_info()

func _on_terrarium_button_pressed(source_button: Button) -> void:
	for button in terrarium_buttons:
		var terrarium = terrariums[terrarium_buttons.find(button)]
		if button != source_button:
			terrarium.toggle_travel(true)
			terrarium_zoom_point.dezoom_node(terrarium)
		else:
			if button.toggle_mode == true:
				button.button_pressed = false
				button.toggle_mode = false
				next_button.disabled = true
			else:
				button.button_pressed = true
				terrarium_select.show()
				terrarium.toggle_travel(false)
				terrarium_zoom_point.zoom_node(terrarium)
				terrarium_select_button.set_select_target(terrarium)
				terrariums_animation_tree.set("parameters/conditions/reset", true)

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

func _on_item_chosen(item : ShopItem):
	if item.info is ShopAbilityInfo:
		sync_info()
		var deck_screen_info := DeckScreenInfo.new()
		deck_screen_info.shop_info = info
		deck_screen_info.ability_info = item.info
		ScreenEvents.request_screen(ScreenEvents.Screen.DECK, deck_screen_info)
	else:
		ShopEvents.purchase_item(item.info)


func _on_deck_pressed() -> void:
	var deck_screen_info := DeckScreenInfo.new()
	deck_screen_info.shop_info = info
	ScreenEvents.request_screen(ScreenEvents.Screen.DECK, deck_screen_info)
