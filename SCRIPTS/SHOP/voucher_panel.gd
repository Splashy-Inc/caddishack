extends PanelContainer

class_name VoucherPanel

@onready var number: Label = $HBoxContainer/Number

func _ready() -> void:
	RunEvents.vouchers_updated.connect(_on_vouchers_updated)
	number.text = str(RunEvents.get_vouchers()) + "V"

func _on_vouchers_updated(new_vouchers: int):
	number.text = str(new_vouchers) + "V"
