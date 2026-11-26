extends PanelContainer

class_name RunInfoPanel

signal number_change_complete

@onready var round_number: Label = $VBoxContainer/RoundNumber
@onready var quota_number: NumberLabel = $VBoxContainer/Quota/QuotaNumber
@onready var score_number: NumberLabel = $VBoxContainer/Score/ScoreNumber
@onready var voucher_number: NumberLabel = $VBoxContainer/Vouchers/VoucherNumber
@onready var customer_image: TextureRect = $VBoxContainer/HBoxContainer/CustomerImage
@onready var sand_control: Control = $VBoxContainer/HBoxContainer/MaterialEffects/SandControl
@onready var sand_slot: Marker2D = $VBoxContainer/HBoxContainer/MaterialEffects/SandControl/SandSlot
@onready var charm_control: Control = $VBoxContainer/HBoxContainer/MaterialEffects/CharmControl
@onready var charm_slot: Marker2D = $VBoxContainer/HBoxContainer/MaterialEffects/CharmControl/CharmSlot
@onready var effect_label: Label = $VBoxContainer/HBoxContainer/MaterialEffects/EffectLabel

var awaiting_quota_change = false
var awaiting_score_change = false
var awaiting_voucher_change = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RunEvents.round_updated.connect(set_round)
	RunEvents.quota_updated.connect(set_quota)
	RunEvents.score_updated.connect(set_score)
	RunEvents.vouchers_updated.connect(set_vouchers)
	quota_number.change_complete.connect(_on_quota_change_complete)
	score_number.change_complete.connect(_on_score_change_complete)
	voucher_number.change_complete.connect(_on_voucher_change_complete)
	
	set_round(RunEvents.get_round(), RunEvents.get_max_rounds())
	set_quota(RunEvents.get_quota(), true, 0.0)
	set_score(RunEvents.get_score(), true, 0.0)
	set_vouchers(RunEvents.get_vouchers(), true, 0.0)
	
	set_customer_info(RunEvents.run_info.get_current_customer())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_round(current_round: int, max_rounds: int):
	round_number.text = str(current_round) + "/" + str(max_rounds)

func set_quota(current_quota: int, silent: bool = false, time : float = 2.0):
	if time > 0:
		awaiting_quota_change = true
	quota_number.set_number(current_quota, time, silent)

func set_score(current_score: int, silent: bool = false, time : float = 2.0):
	if time > 0:
		awaiting_score_change = true
	score_number.set_number(current_score, time, silent)

func set_vouchers(current_vouchers: int, silent: bool = false, time : float = 2.0):
	if time > 0:
		awaiting_voucher_change = true
	voucher_number.set_number(current_vouchers, time, silent)

func set_customer_info(new_customer: CustomerInfo):
	if new_customer != null:
		customer_image.texture = new_customer.image
		
		for child in sand_slot.get_children():
			child.queue_free()
		sand_control.hide()
			
		for child in charm_slot.get_children():
			child.queue_free()
		charm_control.hide()
		
		for material in new_customer.materials:
			if material is SandMaterialInfo:
				var color_material_info = SandMaterialInfo.new()
				color_material_info.add_color(material.colors.front())
				var color = Globals.generate_material(color_material_info)
				color.disable()
				sand_slot.add_child(color)
				sand_control.show()
			elif material is SpecialMaterialInfo:
				var charm_material_info = SpecialMaterialInfo.new()
				charm_material_info.type = material.type
				var charm = Globals.generate_material(charm_material_info)
				charm.disable()
				charm_slot.add_child(charm)
				charm_control.show()
		
		effect_label.hide()
		for key in new_customer.effect.keys():
			if new_customer.effect[key] > 0:
				match key:
					"points":
						effect_label.label_settings = load("uid://36xl0gfrun1m")
					"mult":
						effect_label.label_settings = load("uid://dsbhln5iakbf7")
					"vouchers":
						effect_label.label_settings = load("uid://cl0nus6vr1r1s")
				effect_label.text = "+" + str(new_customer.effect[key])
				effect_label.show()
				break

func _on_quota_change_complete():
	awaiting_quota_change = false
	if not (awaiting_quota_change or awaiting_score_change or awaiting_voucher_change):
		number_change_complete.emit()

func _on_score_change_complete():
	awaiting_score_change = false
	if not (awaiting_quota_change or awaiting_score_change or awaiting_voucher_change):
		number_change_complete.emit()

func _on_voucher_change_complete():
	awaiting_voucher_change = false
	if not (awaiting_quota_change or awaiting_score_change or awaiting_voucher_change):
		number_change_complete.emit()
