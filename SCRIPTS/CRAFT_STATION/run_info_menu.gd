extends Control

class_name RunInfoMenu

signal exited

@onready var money_value: Label = $VBoxContainer/MoneyBox/HBoxContainer/Value
@onready var bead_pile: BeadPile = $VBoxContainer/HBoxContainer/BeadPileBox/BeadPile_Background/SubViewport/BeadPile
@onready var complete_bracelet_panel: BraceletContainer = $VBoxContainer/HBoxContainer/BraceletsBox/Bracelet_Background/SubViewport/CompleteBraceletPanel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_run_info()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_run_info():
	money_value.text = str(Globals.run_info.money)
	bead_pile.set_beads(Globals.run_info.bead_pile)
	complete_bracelet_panel.fill_bracelets(Globals.run_info.bracelets)

func _unhandled_input(event: InputEvent) -> void:
	if visible and event is InputEventKey and event.is_pressed():
		exited.emit()
