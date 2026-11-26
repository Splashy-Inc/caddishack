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
	if new_info != null:
		animated_sprite_2d.sprite_frames = new_info.sprite_frames
		
		for child in sand_slot.get_children():
			child.queue_free()
		sand_control.hide()
			
		for child in charm_slot.get_children():
			child.queue_free()
		charm_control.hide()
		
		for material in new_info.materials:
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
		for key in new_info.effect.keys():
			if new_info.effect[key] > 0:
				match key:
					"points":
						effect_label.label_settings = load("uid://36xl0gfrun1m")
					"mult":
						effect_label.label_settings = load("uid://dsbhln5iakbf7")
					"vouchers":
						effect_label.label_settings = load("uid://cl0nus6vr1r1s")
				effect_label.text = "+" + str(new_info.effect[key])
				effect_label.show()
				break
