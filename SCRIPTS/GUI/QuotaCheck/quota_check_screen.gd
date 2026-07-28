extends PanelContainer

@export var run_info_panel : RunInfoPanel
@export var transfer_time_sec := 2.0

@onready var title: Label = $PanelContainer/VBoxContainer/Title
@onready var next_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/Control3/NextButton
@onready var restart_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/Control3/RestartButton

var check_quota : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_quota = check_quota * 2
	if RunEvents.get_quota() < target_quota:
		var change = clamp(int(check_quota * delta / transfer_time_sec), 1, target_quota - RunEvents.get_quota())
		RunEvents.change_score(clamp(-change, -RunEvents.get_score(), 0))
		RunEvents.set_quota(clamp(RunEvents.get_quota() + change, 0, target_quota))
		if RunEvents.get_quota() == target_quota:
			RunEvents.set_round(1)
			await get_tree().create_timer(1.0).timeout
			ScreenEvents.request_screen(ScreenEvents.Screen.SHOP)

func pass_quota():
	title.text = "Quota Passed!"
	check_quota = RunEvents.get_quota()

func fail_quota():
	title.text = "Quota Failed!"
	next_button.hide()
	restart_button.show()
	#RunEvents.reset_run()
	#await get_tree().create_timer(1.0).timeout
	#ScreenEvents.request_screen(ScreenEvents.Screen.SHOP)

func _on_next_button_pressed() -> void:
	if RunEvents.check_quota():
		pass_quota()
	else:
		fail_quota()
