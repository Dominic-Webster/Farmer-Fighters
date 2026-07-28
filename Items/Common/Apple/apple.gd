# Boosts movement speed
extends Item
class_name Apple

var speed_boost : float = 125.0


func get_item_desc() -> String:
	return "+125 Movement Speed"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Apple"
		RunManager.player.add_item_to_array(item_name)
		if MetaManager != null:
			MetaManager.record_item_pickup("apple")
		RunManager.player.move_speed += speed_boost
		queue_free()
		picked_up.emit(item_name, get_item_desc())
