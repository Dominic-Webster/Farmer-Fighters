# Active: Heal one heart
extends Item
class_name Fish_Emulsion

func get_item_desc() -> String:
	return "Active (6): Heal One Heart"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Fish Emulsion"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.equip_active_item("fish_emulsion", item_name, get_item_desc(), "res://Items/Uncommon/Fish_Emulsion/fish_emulsion_single.png", 6, 6)
		
		
		if MetaManager != null:
			MetaManager.record_item_pickup("fish_emulsion")
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
