extends Station

class_name TerrariumStation

@export var round_length := 10

@onready var card_hand: CardHand = $HandSlot/CardHand
@onready var terrarium: Terrarium = $Terrarium
@onready var bead_scorer: BeadScorer = $BeadScorer
@onready var terrarium_play_slot: Marker2D = $TerrariumPlaySlot
@onready var next_button: Button = $PanelContainer/VBoxContainer/NextButton
@onready var hand_number_label: Label = $HandCountTracker/HBoxContainer/Number
@onready var hand_count_tracker: PanelContainer = $HandCountTracker
@onready var hand_count_animation_player: AnimationPlayer = $HandCountTracker/AnimationPlayer
var num_hands := 2
var hand_num := 1

func _ready() -> void:
	terrarium.travel_to(terrarium_play_slot.transform)
	load_run_info()
	hand_count_tracker.show()
	hand_count_animation_player.play_backwards("fade_out")
	await hand_count_animation_player.animation_finished
	await get_tree().create_timer(1).timeout
	hand_count_animation_player.play("fade_out")

func _process(delta: float) -> void:
	next_button.disabled = not bead_scorer.score > -1 and not terrarium.check_larvae_limit_reached()

func _on_terrarium_larvae_done() -> void:
	hand_num += 1
	if hand_num <= num_hands:
		hand_number_label.text = str(hand_num)
		card_hand.draw_cards(7)
		hand_count_animation_player.play_backwards("fade_out")
		await hand_count_animation_player.animation_finished
		await get_tree().create_timer(1).timeout
		hand_count_animation_player.play("fade_out")

func _on_terrarium_larvae_started() -> void:
	card_hand.discard()

func _on_next_button_pressed() -> void:
	if bead_scorer.is_scoring_complete():
		if not RunEvents.is_final_round():
			RunEvents.increment_round()
			ScreenEvents.request_screen(ScreenEvents.Screen.SHOP)
		else:
			ScreenEvents.request_screen(ScreenEvents.Screen.QUOTA)
	else:
		terrarium.start_larvae(round_length)

func _on_terrarium_bead_limit_reached(full_terrarium: Terrarium) -> void:
	card_hand.hide()
	bead_scorer.show()
	bead_scorer.score_beads(full_terrarium.get_beads())

func _on_bead_scorer_beads_scored(score: int) -> void:
	RunEvents.score_generated.emit(score)
	next_button.disabled = false

func load_run_info():
	terrarium.initialize(RunEvents.get_current_terrarium_info())
