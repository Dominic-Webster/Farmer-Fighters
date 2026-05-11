extends Item
class_name Habanero

var item_name : String = "Habanero"
var fire_rate_boost : float = 0.05


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.fire_rate -= fire_rate_boost
		if RunManager.player.fire_rate < 0.01:
			RunManager.player.fire_rate = 0.01
		queue_free()
		picked_up.emit()
