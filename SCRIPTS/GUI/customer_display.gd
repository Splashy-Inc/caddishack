extends HBoxContainer

class_name CustomerDisplay

@export var customer_info : CustomerInfo

@onready var animated_sprite_2d: AnimatedSprite2D = $CustomerImage/Center/AnimatedSprite2D
@onready var sand_slot: Marker2D = $MaterialEffects/SandControl/SandSlot
@onready var charm_slot: Marker2D = $MaterialEffects/CharmControl/CharmSlot
@onready var sand_control: Control = $MaterialEffects/SandControl
@onready var charm_control: Control = $MaterialEffects/CharmControl
@onready var effect_label: Label = $MaterialEffects/EffectLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_info(customer_info)

func set_info(new_info: CustomerInfo):
	customer_info = new_info
	if customer_info != null:
		animated_sprite_2d.sprite_frames = customer_info.sprite_frames
		if "idle" in animated_sprite_2d.sprite_frames.get_animation_names():
			animated_sprite_2d.play("idle")
		
		for child in sand_slot.get_children():
			child.queue_free()
		sand_control.hide()
			
		for child in charm_slot.get_children():
			child.queue_free()
		charm_control.hide()
		
		for material in customer_info.materials:
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
		for key in customer_info.effect.keys():
			if customer_info.effect[key] > 0:
				match key:
					CustomerInfo.EffectType.POINTS:
						effect_label.label_settings = load("uid://36xl0gfrun1m")
					CustomerInfo.EffectType.MULT:
						effect_label.label_settings = load("uid://dsbhln5iakbf7")
					CustomerInfo.EffectType.VOUCHERS:
						effect_label.label_settings = load("uid://cl0nus6vr1r1s")
				effect_label.text = "+" + str(customer_info.effect[key])
				effect_label.show()
				break

func calculate_bonus_animated(bead_array_info: BeadArrayInfo):
	var affected_beads : Array[BeadInfo]
	for bead_info in bead_array_info.beads:
		var is_match := true
		for material in customer_info.materials:
			if material is SandMaterialInfo:
				for color in material.colors:
					if not color in bead_info.sand.colors:
						is_match = false
						break
			elif material is SpecialMaterialInfo:
				if material.type != bead_info.special.type:
					is_match = false
					break
		
		if is_match and not bead_info in affected_beads:
			affected_beads.append(bead_info)
			BeadEvents.bead_color_highlight_toggle_requested.emit(bead_info, true)
			BeadEvents.bead_charm_highlight_toggle_requested.emit(bead_info, true)
	
	var bonus_points = customer_info.calculate_bonus(bead_array_info, CustomerInfo.EffectType.POINTS)
	var bonus_mult = customer_info.calculate_bonus(bead_array_info, CustomerInfo.EffectType.MULT)
	var bonus_vouchers = customer_info.calculate_bonus(bead_array_info, CustomerInfo.EffectType.VOUCHERS)
	ScoringEvents.customer_scored.emit(bonus_points, bonus_mult, bonus_vouchers)
	await get_tree().create_timer(.5).timeout
	
	for bead_info in affected_beads:
		BeadEvents.bead_color_highlight_toggle_requested.emit(bead_info, false)
		BeadEvents.bead_charm_highlight_toggle_requested.emit(bead_info, false)
