# Active: Deal x3 Damage to all enemies in room
extends Item
class_name Wheat

func get_item_desc() -> String:
	return "Active (5): Deal x3 Damage to all Enemies"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Wheat"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.equip_active_item("wheat", item_name, get_item_desc(), "res://Items/Unlocks/Wheat/wheat.png", 5, 5)
		
		
		if MetaManager != null:
			MetaManager.record_item_pickup("wheat")
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
