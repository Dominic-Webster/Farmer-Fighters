extends Resource
class_name Enemy

@export var enemy_name : String
@export var health := {
	"easy": 3,
	"normal": 5,
	"hard": 8
}
@export var damage := {
	"easy": 1,
	"normal": 2,
	"hard": 3
}
