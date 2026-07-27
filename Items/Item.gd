extends Node2D
class_name Item

@warning_ignore("unused_signal")
signal picked_up(iname : String, desc: String)
signal pickup_requested(item: Item)
signal abandoned(iname : String, desc: String)

@onready var area2d : Area2D = $Area2D

@export var pickup_delay : float = 0.75

var item_name : String
var desc : String


func _ready() -> void:
	add_to_group("item")
	area2d.monitoring = false
	area2d.body_entered.connect(_on_pickup_body_entered)
	_cache_item_name()
	_enable_pickup.call_deferred()


func _enable_pickup() -> void:
	if pickup_delay > 0.0:
		await get_tree().create_timer(pickup_delay).timeout
	area2d.monitoring = true


func _on_pickup_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		area2d.set_deferred("monitoring", false)
		pickup_requested.emit(self)


func abandon_item() -> void:
	abandoned.emit(item_name, get_item_desc())
	queue_free()


func get_item_name() -> String:
	if item_name == "":
		_cache_item_name()
	return item_name


func get_item_desc() -> String:
	return desc


func _cache_item_name() -> void:
	if item_name != "":
		return

	var script: Script = get_script()
	if script == null or not script.has_method("get_source_code"):
		return

	var source_text: String = script.get_source_code()
	if source_text == "":
		return

	var pattern := "item_name\\s*=\\s*\"([^\"]+)\""
	var regex := RegEx.new()
	if regex.compile(pattern) != OK:
		return

	var result := regex.search(source_text)
	if result == null:
		return

	item_name = result.get_string(1)
