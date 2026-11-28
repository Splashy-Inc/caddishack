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

func set_idle():
	if "idle" in animated_sprite_2d.sprite_frames.get_animation_names():
		animated_sprite_2d.play("idle")

func set_happy():
	if "happy" in animated_sprite_2d.sprite_frames.get_animation_names():
		animated_sprite_2d.play("happy")

func toggle_highlight(is_highlighted: bool):
	animated_sprite_2d.material.set_shader_parameter("on", is_highlighted)
