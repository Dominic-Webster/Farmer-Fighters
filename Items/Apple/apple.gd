extends Item
class_name Apple

var item_name : String = "Apple"
var speed_boost : float = 100.0


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.move_speed += speed_boost
		queue_free()
		picked_up.emit()
