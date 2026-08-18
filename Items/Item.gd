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

	var derived_name := _derive_item_name_fallback()
	if derived_name != "":
		item_name = derived_name
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


func _derive_item_name_fallback() -> String:
	var script: Script = get_script()
	if script != null:
		var script_path := str(script.resource_path)
		if script_path != "":
			var name_from_path := _normalize_item_name(script_path.get_file().get_basename())
			if name_from_path != "":
				return name_from_path
		
		var _class_name := String(self.get_class())
		if _class_name != "" and _class_name != "Item":
			var name_from_class := _normalize_item_name(_class_name)
			if name_from_class != "":
				return name_from_class
	
	return ""


func _normalize_item_name(raw_name: String) -> String:
	var normalized := raw_name.strip_edges()
	if normalized == "":
		return ""

	normalized = normalized.replace("-", " ")
	normalized = normalized.replace("_", " ")
	normalized = normalized.replace(".", " ")
	while normalized.contains("  "):
		normalized = normalized.replace("  ", " ")

	var words: PackedStringArray = normalized.split(" ", false)
	if words.is_empty():
		return ""

	var cleaned: Array = []
	for word in words:
		var trimmed := word.strip_edges()
		if trimmed == "":
			continue
		if trimmed.to_lower() == "item" and cleaned.size() > 0:
			continue
		cleaned.append(trimmed)

	if cleaned.is_empty():
		return ""

	var result := ""
	for i in range(cleaned.size()):
		var word := str(cleaned[i])
		if i == 0:
			result += _format_name_word(word)
		else:
			result += " " + _format_name_word(word)

	var lower_result := result.to_lower()
	match lower_result:
		"da pickle":
			return "DA PICKLE"
		"good soil":
			return "Good Soil"
		"grapes of wrath":
			return "Grapes Of Wrath"
		"fish emulsion":
			return "Fish Emulsion"
		"4 leaf clover":
			return "4 Leaf Clover"

	return result


func _format_name_word(word: String) -> String:
	if word == "":
		return ""
	if word.length() <= 1:
		return word
	if word == word.to_upper():
		return word
	return word.substr(0, 1).to_upper() + word.substr(1).to_lower()
