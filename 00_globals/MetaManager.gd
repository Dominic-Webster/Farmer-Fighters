# Meta Manager
extends Node

const BASE_META_PATH := "res://save/Meta/base_meta.json"
const ITEM_UNLOCKS_PATH := "res://Data/item_unlocks.json"
const SAVE_DIR := "user://save/Meta"
const SAVE_PATH := SAVE_DIR + "/current_meta.json"

var meta_data: Dictionary = {}
var item_unlock_definitions: Dictionary = {}


func _ready() -> void:
	load_item_unlock_definitions()
	load_meta_data()
	refresh_item_pools()


func load_item_unlock_definitions() -> void:
	item_unlock_definitions.clear()
	var file = FileAccess.open(ITEM_UNLOCKS_PATH, FileAccess.READ)
	if not file:
		return

	var parsed = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(parsed) == TYPE_DICTIONARY:
		item_unlock_definitions = parsed


func load_meta_data() -> void:
	meta_data = _load_base_meta_data()
	if not FileAccess.file_exists(SAVE_PATH):
		_reconcile_unlocks(false)
		save_meta_data()
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return

	var parsed = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(parsed) == TYPE_DICTIONARY:
		meta_data = _merge_meta_data(meta_data, parsed)

	_reconcile_unlocks(false)

	_save_if_needed()


func save_meta_data() -> void:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open meta save file for writing: " + SAVE_PATH)
		return

	file.store_string(JSON.stringify(meta_data))
	file.close()


func reset_progress_to_base() -> void:
	meta_data = _load_base_meta_data()
	save_meta_data()
	refresh_item_pools()


func record_item_pickup(item_id: String) -> void:
	if item_id == "":
		return

	var pickup_counts: Dictionary = meta_data.get("pickup_counts", {})
	pickup_counts[item_id] = int(pickup_counts.get(item_id, 0)) + 1
	meta_data["pickup_counts"] = pickup_counts
	_reconcile_unlocks(true)
	save_meta_data()


func record_enemy_kill(amount: int = 1) -> void:
	if amount <= 0:
		return

	meta_data["enemy_kills"] = int(meta_data.get("enemy_kills", 0)) + amount
	_reconcile_unlocks(true)
	save_meta_data()


func is_item_unlocked(item_id: String) -> bool:
	var item_unlocks: Dictionary = meta_data.get("item_unlocks", {})
	return bool(item_unlocks.get(item_id, false))


func unlock_item(item_id: String) -> void:
	_set_item_unlocked(item_id, true)


func _set_item_unlocked(item_id: String, show_notification: bool) -> void:
	if item_id == "" or is_item_unlocked(item_id):
		return

	var item_unlocks: Dictionary = meta_data.get("item_unlocks", {})
	item_unlocks[item_id] = true
	meta_data["item_unlocks"] = item_unlocks
	save_meta_data()
	refresh_item_pools()

	if show_notification and RunManager != null and RunManager.gui != null:
		var unlock_definition = get_item_unlock_definition(item_id)
		var unlock_title = str(unlock_definition.get("unlock_title", "Item Unlocked!"))
		var display_name = str(unlock_definition.get("display_name", item_id.capitalize()))
		RunManager.gui.show_unlock_info(unlock_title, display_name)


func get_item_unlock_definition(item_id: String) -> Dictionary:
	return item_unlock_definitions.get(item_id, {})


func refresh_item_pools() -> void:
	if ItemManager == null:
		return

	ItemManager.load_item_pools()

	for item_id in _get_unlocked_item_ids():
		var item_definition = get_item_unlock_definition(item_id)
		var rarity = str(item_definition.get("rarity", "common"))
		var scene_path = str(item_definition.get("scene_path", ""))
		if scene_path != "":
			ItemManager.add_item_to_pool(rarity, scene_path)


func _reconcile_unlocks(show_notification: bool) -> void:
	var pickup_counts: Dictionary = meta_data.get("pickup_counts", {})
	var enemy_kills := int(meta_data.get("enemy_kills", 0))
	for unlock_id in item_unlock_definitions.keys():
		var unlock_definition = item_unlock_definitions.get(unlock_id, {})
		var source_item := str(unlock_definition.get("source_item", ""))
		var required_pickups = int(unlock_definition.get("required_pickups", 0))
		var required_enemy_kills = int(unlock_definition.get("required_enemy_kills", 0))

		if required_pickups <= 0 and required_enemy_kills <= 0:
			continue

		var meets_pickup_requirement := true
		if required_pickups > 0:
			if source_item == "":
				meets_pickup_requirement = false
			else:
				meets_pickup_requirement = int(pickup_counts.get(source_item, 0)) >= required_pickups

		var meets_kill_requirement := required_enemy_kills <= 0 or enemy_kills >= required_enemy_kills

		if meets_pickup_requirement and meets_kill_requirement:
			_set_item_unlocked(unlock_id, show_notification)


func _get_unlocked_item_ids() -> Array:
	var unlocked_items: Array = []
	var item_unlocks: Dictionary = meta_data.get("item_unlocks", {})

	for item_id in item_unlocks.keys():
		if bool(item_unlocks[item_id]):
			unlocked_items.append(item_id)

	return unlocked_items


func _load_base_meta_data() -> Dictionary:
	var file = FileAccess.open(BASE_META_PATH, FileAccess.READ)
	if file == null:
		return {
			"version": 1,
			"enemy_kills": 0,
			"pickup_counts": {},
			"item_unlocks": {}
		}

	var parsed = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(parsed) != TYPE_DICTIONARY:
		return {
			"version": 1,
			"enemy_kills": 0,
			"pickup_counts": {},
			"item_unlocks": {}
		}

	return _normalize_meta_data(parsed)


func _normalize_meta_data(raw_meta: Dictionary) -> Dictionary:
	var normalized := {
		"version": int(raw_meta.get("version", 1)),
		"enemy_kills": int(raw_meta.get("enemy_kills", 0)),
		"pickup_counts": {},
		"item_unlocks": {},
	}

	var pickup_counts: Dictionary = raw_meta.get("pickup_counts", {})
	if pickup_counts.is_empty() and raw_meta.has("brocolli_picked_up"):
		pickup_counts["broccoli"] = int(raw_meta.get("brocolli_picked_up", 0))

	normalized["pickup_counts"] = pickup_counts.duplicate(true)
	normalized["item_unlocks"] = raw_meta.get("item_unlocks", {}).duplicate(true)
	return normalized


func _merge_meta_data(base_meta: Dictionary, saved_meta: Dictionary) -> Dictionary:
	var merged := _normalize_meta_data(base_meta)
	var normalized_saved := _normalize_meta_data(saved_meta)

	merged["version"] = int(normalized_saved.get("version", merged.get("version", 1)))
	merged["enemy_kills"] = int(normalized_saved.get("enemy_kills", merged.get("enemy_kills", 0)))

	var merged_pickup_counts: Dictionary = merged.get("pickup_counts", {})
	for pickup_key in normalized_saved.get("pickup_counts", {}).keys():
		merged_pickup_counts[pickup_key] = int(normalized_saved["pickup_counts"][pickup_key])
	merged["pickup_counts"] = merged_pickup_counts

	var merged_item_unlocks: Dictionary = merged.get("item_unlocks", {})
	for unlock_key in normalized_saved.get("item_unlocks", {}).keys():
		merged_item_unlocks[unlock_key] = bool(normalized_saved["item_unlocks"][unlock_key])
	merged["item_unlocks"] = merged_item_unlocks

	return merged


func _save_if_needed() -> void:
	if meta_data.is_empty():
		meta_data = _load_base_meta_data()
	save_meta_data()
