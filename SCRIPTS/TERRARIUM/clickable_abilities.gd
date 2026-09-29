extends VBoxContainer

class_name ClickableAbilities

signal ability_selected

@export var ability_slots: Array[CardAbilitySlot]

func _ready() -> void:
	#for ability_slot in ability_slots:
		#ability_slot.toggled.connect(_on_ability_toggled.bind(ability_slot))
	#
	#if ability_slots.size() > 0:
		#ability_slots.front().button_pressed = true
	pass

func _on_ability_toggled(toggled_on: bool, toggled_ability_slot: CardAbilitySlot):
	if toggled_on:
		for ability_slot in ability_slots:
			if ability_slot != toggled_ability_slot:
				ability_slot.set_pressed_no_signal(false)
			else:
				ability_selected.emit(toggled_ability_slot.ability_info)
	else:
		toggled_ability_slot.set_pressed_no_signal(true)

func load_abilities(new_abilities: Array[AbilityInfo]) -> bool:
	var has_ability = false
	#for i in ability_slots.size():
		#if i < new_abilities.size():
			#ability_slots[i].load_ability_info(new_abilities[i])
			#ability_slots[i].show()
			#has_ability = true
		#else:
			#ability_slots[i].clear()
			#ability_slots[i].hide()
	return has_ability
