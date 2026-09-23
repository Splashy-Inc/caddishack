extends Resource

class_name RunInfo

@export var cur_round := 0
@export var max_rounds := 3
@export var cur_quota := 100
@export var score := 0
@export var vouchers := 0
@export var deck : DeckInfo
@export var default_names := ["James","Jimbo","J.J.","Jay","Jamie","Jim","Jim Jim","Jim Jam","Slim Jim","Jimothy","Jiminy ","Jimmy-John","Jimmy-Jane","Jimmy-Joe","Jimmy-Lee","Jimmy-Rose","Jimmy-Jean","Jimmy-Dean","Jimmy-Ellie-May","Donald",]
@export var available_shop_abilities := [preload("uid://cjcvtvdc83kbk"),
										preload("uid://cr1v4818qsbg4"),
										preload("uid://d24uyn8orn65n"),
										preload("uid://cxuu8ukrpbpy7"),
										preload("uid://b68ptgvp5mhj3"),
										preload("uid://b717al2bimweq"),
										preload("uid://dw4nxo1xjbug4"),
										preload("uid://csk0mcs73aud0"),
										preload("uid://dq85imxfshxej"),
										preload("uid://cu2a7esxr4q2v"),] as Array[ShopAbilityInfo]
@export var unlocked_abilities := [preload("uid://bh14q3x27s0si"),
									preload("uid://dcynpenj2s130"),
									preload("uid://8cdcook8lkoo"),
									preload("uid://bbuq5n0pob56i"),
									preload("uid://dwmp14ku03fm"),
									preload("uid://co053gn62jucq"),
									preload("uid://31shunna6n1a"),
									preload("uid://dtprlafpcjuvc"),
									preload("uid://dygxageaewodg"),
									preload("uid://5bx2xh3vbjqi"),
]
