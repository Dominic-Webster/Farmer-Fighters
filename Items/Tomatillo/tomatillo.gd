# Unlocks additional backwards bullet, or increase movement speed
extends Item
class_name Tomatillo

var move_speed_buff : float = 150

func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Tomatillo"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.tomatillo == false:
			desc = "Extra Bullet"
			RunManager.player.tomatillo = true
		else:
			desc = "+ Move Speed"
			RunManager.player.move_speed += move_speed_buff
		
		queue_free()
		picked_up.emit(item_name, desc)
