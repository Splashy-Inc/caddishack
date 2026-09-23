extends UIButton

@export var cost := 1

func _button_ready() -> void:
	RunEvents.vouchers_updated.connect(_on_vouchers_updated)
	# TODO: Make voucher icon/symbol
	text = "Reroll All " + str(cost) + "V"
	_on_vouchers_updated(RunEvents.get_vouchers())

func _on_vouchers_updated(new_vouchers: int):
	disabled = new_vouchers < cost

func _on_pressed() -> void:
	change_cost(cost)

func change_cost(change: int):
	cost += change
	text = "Reroll All " + str(cost) + "V"
	_on_vouchers_updated(RunEvents.get_vouchers())
