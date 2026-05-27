# Item Manager
extends Node

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
		return default_pool[randi() % default_pool.size()]
	return ""


func load_item_pools():
	var file = FileAccess.open("res://Data/item_pool.json", FileAccess.READ)
	if file:
		item_pools = JSON.parse_string(file.get_as_text())
		file.close()


func get_random_item(rarity : String) -> String:
	if item_pools.has(rarity) and item_pools[rarity].size() > 0:
		var idx = randi() % item_pools[rarity].size()
		var item = item_pools[rarity][idx]
		item_pools[rarity].remove_at(idx)
		return item
	return ""


func add_item_to_pool(rarity : String, item : String) -> void:
	if not item_pools.has(rarity):
		item_pools[rarity] = []
	item_pools[rarity].append(item)
