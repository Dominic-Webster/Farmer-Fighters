extends Area2D
class_name Hazard

@export var damage : int = 1


func _ready() -> void:
	add_to_group("hazard")
