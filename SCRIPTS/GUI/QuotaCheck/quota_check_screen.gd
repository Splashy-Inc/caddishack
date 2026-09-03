extends PanelContainer

@onready var run_info: RunInfoPanel = $PanelContainer/VBoxContainer/HBoxContainer/RunInfo
@onready var title: Label = $PanelContainer/VBoxContainer/Title
@onready var next_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/Control3/NextButton
@onready var restart_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/Control3/RestartButton

var quota_passed := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pass_quota():
	title.text = "Quota Passed!"
	quota_passed = true
	next_button.disabled = true
	RunEvents.change_score(-RunEvents.get_quota())
	RunEvents.change_quota(RunEvents.get_quota())
	await run_info.number_change_complete
	next_button.disabled = false

func fail_quota():
	title.text = "Quota Failed!"
	quota_passed = false
	next_button.hide()
	restart_button.show()

func _on_next_button_pressed() -> void:
	if quota_passed:
		RunEvents.set_round(1)
		await get_tree().create_timer(1.0).timeout
		ScreenEvents.request_screen(ScreenEvents.Screen.SHOP)
	elif RunEvents.check_quota():
		pass_quota()
	else:
		fail_quota()
