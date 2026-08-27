# x2 Damage
extends Item
class_name Mango

func get_item_desc() -> String:
	return "x2 Damage"

func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Mango"
		RunManager.player.add_item_to_array(item_name)
		
		RunManager.player.damage *= 2
		
		if MetaManager != null:
			MetaManager.record_item_pickup("mango")
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
