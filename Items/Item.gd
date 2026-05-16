extends Node2D
class_name Item

signal picked_up(iname : String, desc: String)

@onready var area2d : Area2D = $Area2D

var item_name : String
var desc : String


func _ready() -> void:
	add_to_group("item")
	area2d.body_entered.connect(_on_body_entered)


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		picked_up.emit(item_name, desc)
