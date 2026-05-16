extends Item
class_name GoodSoil

var health_boost : int = 2


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Good Soil"
		desc = "+ Health"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.max_health += health_boost
		RunManager.player.current_health += health_boost
		RunManager.player.damaged.emit()
		queue_free()
		picked_up.emit(item_name, desc)
