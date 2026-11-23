extends Resource

class_name CustomerInfo

@export var image : Texture2D
@export var positive_material : MaterialInfo
@export var positive_effect := {
	"points": 0,
	"mult": 0,
	"vouchers": 0,
}
@export var negative_material : MaterialInfo
@export var negative_effects := {
	"points": 0,
	"mult": 0,
	"vouchers": 0,
}
