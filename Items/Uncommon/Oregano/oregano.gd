# Give 2 Avacado Hearts
extends Item
class_name Oregano

var temp_health_boost : int = 4


func get_item_desc() -> String:
	return "Gain 2 Avacado Hearts"

func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Oregano"
		RunManager.player.add_item_to_array(item_name)
		
		RunManager.player.add_temp_health(temp_health_boost)
		
		if MetaManager != null:
			MetaManager.record_item_pickup("oregano")
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
