extends Item
class_name Radish


var dash_speed_buff : float = 250


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Radish"
		desc = "Dash (+ Speed)"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.dash_unlocked == false:
			RunManager.player.dash_unlocked = true
			RunManager.player.dash_speed += 100
		else:
			RunManager.player.dash_speed += dash_speed_buff
		
		queue_free()
		picked_up.emit(item_name, desc)
