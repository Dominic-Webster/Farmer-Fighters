extends Node2D
class_name PickUp

signal picked_up(pname : String, desc : String)

@onready var area2d : Area2D = $Area2D

@export var pickup_delay : float = 0.25

var pickup_name : String
var desc : String

func _ready() -> void:
	add_to_group("pickup")
	area2d.monitoring = false
	area2d.body_entered.connect(_on_body_entered)
	_enable_pickup.call_deferred()


func _enable_pickup() -> void:
	if pickup_delay > 0.0:
		await get_tree().create_timer(pickup_delay).timeout
	area2d.monitoring = true


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		picked_up.emit(pickup_name, desc)
