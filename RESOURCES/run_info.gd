extends Resource

class_name RunInfo

@export var cur_round := 0
@export var max_rounds := 3
@export var cur_quota := 100
@export var score := 0
@export var deck : DeckInfo
@export var default_names := ["James","Jimbo","J.J.","Jay","Jamie","Jim","Jim Jim","Jim Jam","Slim Jim","Jimothy","Jiminy ","Jimmy-John","Jimmy-Jane","Jimmy-Joe","Jimmy-Lee","Jimmy-Rose","Jimmy-Jean","Jimmy-Dean","Jimmy-Ellie-May","Donald",]
@export var available_shop_abilities := [preload("uid://cjcvtvdc83kbk"),
										preload("uid://cr1v4818qsbg4"),
										preload("uid://d24uyn8orn65n"),
										preload("uid://cxuu8ukrpbpy7"),
										preload("uid://b68ptgvp5mhj3"),
										preload("uid://b717al2bimweq"),
										preload("uid://dw4nxo1xjbug4"),
										preload("uid://csk0mcs73aud0"),] as Array[ShopAbilityInfo]
