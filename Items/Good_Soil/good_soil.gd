extends Item
class_name GoodSoil

var item_name : String = "Good Soil"
var health_boost : int = 2


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.max_health += health_boost
		RunManager.player.current_health += health_boost
		RunManager.player.damaged.emit()
		queue_free()
		picked_up.emit()
