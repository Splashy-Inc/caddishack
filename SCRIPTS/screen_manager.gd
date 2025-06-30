extends Node

@export var station_scene: PackedScene

@onready var hud: HUD = $HUD

var station: Station
var game_ended = false
var paused = true

# Called when the node enters the scene tree for the first time.
func _ready():
	show_main_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _resume_play(mouse_mode: int = Input.MOUSE_MODE_VISIBLE):
	paused = false
	hud.hide_menus()
	if station and station.has_method("resume_play"):
		station.resume_play(mouse_mode)

func _pause_play():
	paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if station and station.has_method("pause_play"):
		station.pause_play()

func show_main_menu():
	_pause_play()
	if station:
		station.queue_free()
		station = null
	hud.show_main_menu()

func toggle_pause_menu():
	if hud.cur_menu != HUD.Menus.MAIN and hud.cur_menu != HUD.Menus.CONTROLS:
		if not paused:
			_pause_play()
			hud.show_pause_menu()
		else:
			_resume_play()

func toggle_run_info():
	if hud.cur_menu != HUD.Menus.MAIN and hud.cur_menu != HUD.Menus.CONTROLS:
		if not paused:
			_pause_play()
			hud._show_run_info()
		else:
			_resume_play()

func _on_quit_pressed():
	get_tree().quit()

func _on_play_pressed():
	if game_ended or not station:
		_on_restart_pressed()
	else:
		_resume_play()

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause_menu()
	elif event.is_action_pressed("run_info"):
		toggle_run_info()
		get_viewport().set_input_as_handled()

func _restart_station():
	game_ended = false
	if station:
		station.queue_free()
	
	var new_station = station_scene.instantiate()
	add_child(new_station)
	for sig in new_station.get_signal_list():
		match sig["name"]:
			"lost":
				new_station.lost.connect(_on_station_lost)
			"won":
				new_station.won.connect(_on_station_won)
	
	# Sample code in case there's a tutorial station in the game that would use it
	#for sig in new_station.get_signal_list():
		#if sig["name"] == "tutorial_completed":
			#new_station.tutorial_completed.connect(_on_tutorial_won)
			#break
	
	station = new_station
	station.load_run_info()

func _on_restart_pressed():
	# TODO: Get resetting to behave as expected (doesn't actually reset run at this point)
	Globals.reset_run()
	_set_station(Globals.ordered_stations.back())
	_restart_station()
	_resume_play()

func _on_station_lost():
	game_ended = true
	hud.show_loss_screen()

func _on_station_won(station: Station):
	#game_ended = true
	#_pause_play()
	#hud.show_win_screen()
	for bracelet in Globals.run_info.bracelets:
		if bracelet.bead_array_info.get_beads().is_empty():
			next_station()
			return
	hud.show_win_screen()

func _on_station_selected(new_station_scene: PackedScene):
	_set_station(new_station_scene)

func next_station():
	_set_station(Globals.ordered_stations[(Globals.ordered_stations.find(station_scene) + 1) % Globals.ordered_stations.size()])

func _set_station(new_station_scene: PackedScene):
	station_scene = new_station_scene
	Globals.cur_station_scene = station_scene
	_restart_station()
	_resume_play()

func _on_main_menu_pressed() -> void:
	show_main_menu()
