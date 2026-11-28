extends Resource

class_name BraceletInfo

@export var bead_array_info := BeadArrayInfo.new()

const POINTS_BASE := 0
const MULT_BASE := 0

var points := POINTS_BASE
var mult := MULT_BASE
var value := 0
var vouchers := 0

func calculate_points(customer: CustomerInfo = null) -> int:
	points = POINTS_BASE
	
	for bead in bead_array_info.get_beads():
		points += bead.calculate_points(bead_array_info) * bead.calculate_base_multiplier(bead_array_info)
		if customer:
			points += customer.calculate_bonus(bead, CustomerInfo.EffectType.POINTS)
	
	return points

func calculate_mult(customer: CustomerInfo = null) -> int:
	mult = MULT_BASE
	
	for bead in bead_array_info.get_beads():
		mult += bead.calculate_mult(bead_array_info) * bead.calculate_base_multiplier(bead_array_info)
		if customer:
			mult += customer.calculate_bonus(bead, CustomerInfo.EffectType.MULT)
	
	return mult

func calculate_value(customer: CustomerInfo = null) -> int:
	points = calculate_points(customer)
	mult = calculate_mult(customer)
	value = points * mult
	return value

func calculate_vouchers(customer: CustomerInfo = null) -> int:
	vouchers = 0
	
	for bead in bead_array_info.get_beads():
		vouchers += bead.calculate_vouchers(bead_array_info)
		if customer:
			vouchers += customer.calculate_bonus(bead, CustomerInfo.EffectType.VOUCHERS)
	
	return vouchers

func get_bead_array_info() -> BeadArrayInfo:
	return bead_array_info

func set_bead_array_info(new_info):
	bead_array_info = new_info
