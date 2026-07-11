# Boosts movement speed
extends Item
class_name Apple

var speed_boost : float = 125.0


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Apple"
		desc = "+ Move Speed"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.move_speed += speed_boost
		queue_free()
		picked_up.emit(item_name, desc)
