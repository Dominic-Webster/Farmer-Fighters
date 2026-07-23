# Item Manager
extends Node

const ITEM_POOL_PATH := "res://Data/item_pool.json"

var default_pool = [
	"res://Items/Broccoli/broccoli.tscn",
	"res://Items/Habanero/habanero.tscn",
	"res://Items/Fertilizer/fertilizer.tscn",
	"res://Items/Apple/apple.tscn"
]

var item_pools = {}


func _ready() -> void:
	load_item_pools()


# Get a random item from the default pool
func get_default_item() -> String:
	if default_pool.size() > 0:
		return default_pool[RunManager.rng.randi() % default_pool.size()]
	return ""


func load_item_pools():
	item_pools.clear()
	var file = FileAccess.open(ITEM_POOL_PATH, FileAccess.READ)
	if not file:
		return

	var parsed = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(parsed) == TYPE_DICTIONARY:
		item_pools = parsed

	_apply_meta_unlocks()


func get_random_item(rarity : String) -> String:
	if item_pools.has(rarity) and item_pools[rarity].size() > 0:
		var idx = RunManager.rng.randi() % item_pools[rarity].size()
		var item = item_pools[rarity][idx]
		item_pools[rarity].remove_at(idx)
		return item
	return ""


func add_item_to_pool(rarity : String, item : String) -> void:
	if rarity == "" or item == "":
		return

	if not item_pools.has(rarity):
		item_pools[rarity] = []
	if item not in item_pools[rarity]:
		item_pools[rarity].append(item)


func _apply_meta_unlocks() -> void:
	if typeof(MetaManager) == TYPE_NIL:
		return

	var meta_unlocks: Dictionary = MetaManager.meta_data.get("item_unlocks", {})
	if meta_unlocks.is_empty():
		return

	var item_unlock_definitions: Dictionary = MetaManager.item_unlock_definitions
	for item_id in meta_unlocks.keys():
		if not bool(meta_unlocks[item_id]):
			continue

		var unlock_definition: Dictionary = item_unlock_definitions.get(item_id, {})
		var rarity := str(unlock_definition.get("rarity", ""))
		var scene_path := str(unlock_definition.get("scene_path", ""))
		if rarity != "" and scene_path != "":
			add_item_to_pool(rarity, scene_path)
