extends Sprite2D

class_name BeadSlot

@onready var slot_center: Marker2D = $SlotCenter
@onready var points_label: Label = $Value/Points
@onready var mult_label: Label = $Value/Mult
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fail_sound: AudioStreamPlayer = $FailSound

@export var ability_icons : Array[AbilityIcon]

@export var highlight_timeout := .25

var points := 0
var mult := 0

var scoring_sound : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_value()
	reset_icons()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_abilities(abilities: Array[BeadAbilityInfo]):
	reset_icons()
	for i in ability_icons.size():
		if i < abilities.size():
			ability_icons[i].load_icons(abilities[i])
			ability_icons[i].show()
		else:
			ability_icons[i].reset_icon()
			ability_icons[i].hide()

func reset_icons():
	for icon in ability_icons:
		icon.reset_icon()
		icon.hide()

func reset_value():
	set_points(0)
	points_label.text = ""
	set_mult(0)
	mult_label.text = ""

func has_bead():
	return slot_center.get_child_count() > 0

func add_bead(new_bead: Bead):
	if not has_bead():
		if new_bead.get_parent():
			new_bead.reparent(slot_center)
		else:
			slot_center.add_child(new_bead)
		
		load_abilities(new_bead.info.abilities)
		return true
	return false

func get_bead() -> Bead:
	if slot_center.get_child_count() > 0:
		return slot_center.get_children().front()
	return null

func set_points(new_points: int):
	if is_instance_valid(scoring_sound):
		scoring_sound.play()
	points = new_points
	points_label.text = str(points)

func set_mult(new_mult: int):
	if is_instance_valid(scoring_sound):
		scoring_sound.play()
	mult = new_mult
	mult_label.text = str(new_mult)

func calculate_value(info: BeadArrayInfo):
	var bead := get_bead()
	if is_instance_valid(bead):
		for bead_info in info.beads:
			if bead.info == bead_info:
				set_points(bead_info.calculate_points(info))
				set_mult(bead_info.calculate_mult(info))

func calculate_value_animated(bead_array_info: BeadArrayInfo, new_scoring_sound: AudioStreamPlayer = null):
	var bead := get_bead()
	if is_instance_valid(bead):
		for bead_info in bead_array_info.beads:
			if bead.info == bead_info:
				scoring_sound = new_scoring_sound
				lift_bead()
				var value_breakdown := bead_info.get_value_breakdown(bead_array_info)
				var bead_points = value_breakdown["color_points"]
				var bead_mult = value_breakdown["charm_mult"]
				
				set_points(bead_points)
				bead.toggle_color_highlight(true)
				await get_tree().create_timer(highlight_timeout).timeout
				bead.toggle_color_highlight(false)
				
				set_mult(bead_mult)
				bead.toggle_charm_highlight(true)
				await get_tree().create_timer(highlight_timeout).timeout
				bead.toggle_charm_highlight(false)
				
				for ability_info in bead_info.abilities:
					for icon in ability_icons:
						if icon.info == ability_info:
							var ability_value = 0
							if ability_info is BeadColorAbilityInfo:
								icon.toggle_active(true)
								for affected_bead_info in value_breakdown["abilities"][ability_info]["affected_beads"]:
									BeadEvents.bead_color_highlight_toggle_requested.emit(affected_bead_info, true)
								ability_value += value_breakdown["abilities"][ability_info]["value"]
								if ability_value > 0:
									set_points(bead_points + ability_value)
								else:
									fail_sound.play()
							elif ability_info is BeadCharmAbilityInfo:
								icon.toggle_active(true)
								for affected_bead_info in value_breakdown["abilities"][ability_info]["affected_beads"]:
									BeadEvents.bead_charm_highlight_toggle_requested.emit(affected_bead_info, true)
								ability_value += value_breakdown["abilities"][ability_info]["value"]
								if ability_value > 0:
									set_mult(bead_mult + ability_value)
								else:
									fail_sound.play()
							else:
								continue
							await get_tree().create_timer(highlight_timeout*2).timeout
							for affected_bead_info in value_breakdown["abilities"][ability_info]["affected_beads"]:
								BeadEvents.bead_color_highlight_toggle_requested.emit(affected_bead_info, false)
								BeadEvents.bead_charm_highlight_toggle_requested.emit(affected_bead_info, false)
							icon.toggle_active(false)
				scoring_sound = null
				set_points(bead_info.calculate_points(bead_array_info))
				set_mult(bead_info.calculate_mult(bead_array_info))
				complete_bead_scoring()
				unlift_bead()

func lift_bead():
	animation_player.play("lift_bead", -1, 6.0)

func unlift_bead():
	animation_player.play("lift_bead", -1, -6.0, true)

func complete_bead_scoring():
	ScoringEvents.bead_scored.emit(points, mult)
