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
										preload("uid://cu2a7esxr4q2v"),
										preload("uid://blcrvgu1rxyv4"),
										preload("uid://bacpw2uu31kbt"),
										preload("uid://5yo28sf7i477"),
										preload("uid://b7ntscw1laowj"),
										preload("uid://fdyjr813lja0"),
										preload("uid://mtbiv4n3xnhn"),
										preload("uid://spc2a2io8q1e"),
										preload("uid://ct5lc8wf0jp1d"),
										preload("uid://o06g7xaxwj5h"),
										preload("uid://6a3gv2y8vhvt"),] as Array[ShopAbilityInfo]
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
									preload("uid://c2b24aqm8ksg6"),
									preload("uid://c4hv0ggmu1bwy"),
									preload("uid://c7u24lvgdwck"),
									preload("uid://5878tyywqm83"),
									preload("uid://oiu4b8v21yhr"),
									preload("uid://dfnqv318f6dtl"),
									preload("uid://b6mil5n48aoqh"),
									preload("uid://cdojupsya5lif"),
									preload("uid://cbtroclmkmpv1"),
									preload("uid://bsbxutibgv8an"),
]
@export var wombo_combo_base := preload("uid://2nv6ye62w0df")
