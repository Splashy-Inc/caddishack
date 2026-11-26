extends PanelContainer

@onready var title: Label = $PanelContainer/VBoxContainer/HBoxContainer2/Title
@onready var next_button: UIButton = $PanelContainer/VBoxContainer/HBoxContainer2/VBoxContainer/NextButton
@onready var restart_button: UIButton = $PanelContainer/VBoxContainer/HBoxContainer2/VBoxContainer/RestartButton
@onready var pass_particles: GPUParticles2D = $PassParticles

var quota_passed := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

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
