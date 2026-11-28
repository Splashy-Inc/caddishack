extends PanelContainer

class_name QuotaCheck

@export var customer_displays : Array[CustomerDisplay]
@export var bracelets : Array[Bracelet]
@export var scores_labels : Array[NumberLabel]

@onready var title: Label = $PanelContainer/VBoxContainer/HBoxContainer2/Title
@onready var next_button: UIButton = $PanelContainer/VBoxContainer/HBoxContainer2/VBoxContainer/NextButton
@onready var restart_button: UIButton = $PanelContainer/VBoxContainer/HBoxContainer2/VBoxContainer/RestartButton
@onready var pass_particles: GPUParticles2D = $PassParticles
@onready var quota_number_label: NumberLabel = $PanelContainer/VBoxContainer/QuotaSummary/PanelContainer/VBoxContainer/QuotaRow/QuotaNumber
@onready var total_score_label: NumberLabel = $PanelContainer/VBoxContainer/QuotaSummary/PanelContainer/VBoxContainer/QuotaRow/TotalScore

var quota_passed := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent().get_path() == NodePath("/root"):
		load_quota_info(RunEvents.test_run_info.get_current_quota_info())
	else:
		load_quota_info(RunEvents.run_info.get_current_quota_info())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pass_quota():
	pass_particles.emitting = true
	title.text = "Quota Passed!"
	quota_passed = true
	next_button.disabled = true
	RunEvents.change_score(-RunEvents.get_quota())
	next_button.disabled = false

func fail_quota():
	AudioServer.set_bus_effect_enabled(1, 0, true)
	title.text = "Quota Failed!"
	quota_passed = false
	next_button.hide()
	restart_button.show()

func _on_next_button_pressed() -> void:
	if quota_passed:
		var new_quota = QuotaInfo.new()
		new_quota.quota = 2 * RunEvents.get_quota()
		if RunEvents.set_new_quota(new_quota, true):
			await get_tree().create_timer(1.0).timeout
			ScreenEvents.request_screen(ScreenEvents.Screen.SHOP)
		else:
			print("Non-infinite game won!")
	elif RunEvents.check_quota():
		pass_quota()
	else:
		fail_quota()

func load_quota_info(new_info: QuotaInfo):
	var total_score := 0
	for i in new_info.rounds.size():
		if i < customer_displays.size():
			if new_info.rounds[i].customer != null:
				customer_displays[i].set_info(new_info.rounds[i].customer)
		if i < bracelets.size():
			if new_info.rounds[i].bracelet != null:
				bracelets[i].set_beads(new_info.rounds[i].bracelet.bead_array_info)
				var bracelet_score = new_info.rounds[i].bracelet.calculate_value(new_info.rounds[i].customer)
				scores_labels[i].set_number(bracelet_score, 1.0)
				total_score += bracelet_score
	
	quota_number_label.set_number(new_info.quota)
	total_score_label.set_number(total_score, 1.0)
