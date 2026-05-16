extends Node2D
class_name PickUp

signal picked_up(pname : String, desc : String)

@onready var area2d : Area2D = $Area2D

var pickup_name : String
var desc : String

func _ready() -> void:
	add_to_group("pickup")
	area2d.body_entered.connect(_on_body_entered)


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		picked_up.emit(pickup_name, desc)
