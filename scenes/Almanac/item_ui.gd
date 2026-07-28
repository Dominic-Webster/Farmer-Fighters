extends Control
class_name ItemUI

const QUESTION_MARK_TEXTURE : Texture2D = preload("res://scenes/Almanac/question_mark.png")

@onready var art : TextureRect = $TextureRect

signal item_hovered(item_ui: ItemUI)
signal item_unhovered(item_ui: ItemUI)

@export var placeholder_texture : Texture2D = QUESTION_MARK_TEXTURE

var item_id : String = ""
var item_name : String = ""
var item_desc : String = ""
var item_texture : Texture2D
var item_found : bool = false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	if placeholder_texture == null:
		placeholder_texture = QUESTION_MARK_TEXTURE
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	if custom_minimum_size == Vector2.ZERO:
		custom_minimum_size = Vector2(200, 200)
	_update_visuals()
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func setup(id: String, display_name: String, description: String, texture: Texture2D, found: bool) -> void:
	item_id = id
	item_name = display_name
	item_desc = description
	item_texture = texture
	item_found = found
	_update_visuals()


func get_item_id() -> String:
	return item_id


func get_item_name() -> String:
	return item_name if item_found else "???"


func get_item_desc() -> String:
	return item_desc if item_found else ""


func is_item_found() -> bool:
	return item_found


func set_item_found(found: bool) -> void:
	item_found = found
	_update_visuals()


func set_placeholder_texture(texture: Texture2D) -> void:
	placeholder_texture = texture
	_update_visuals()


func _update_visuals() -> void:
	if art == null:
		return

	if item_found and item_texture != null:
		art.texture = item_texture
		art.modulate = Color.WHITE
	else:
		art.texture = placeholder_texture if placeholder_texture != null else item_texture
		art.modulate = Color(0.75, 0.75, 0.75, 1.0)


func _on_mouse_entered() -> void:
	item_hovered.emit(self)


func _on_mouse_exited() -> void:
	item_unhovered.emit(self)
