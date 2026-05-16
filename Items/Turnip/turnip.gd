extends Item
class_name Turnip

var dash_cooldown_buff : float = 0.2


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Turnip"
		desc = "Dash (+ Cooldown)"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.dash_unlocked == false:
			RunManager.player.dash_unlocked = true
			RunManager.player.dash_cooldown -= 0.05
		else:
			RunManager.player.dash_cooldown -= dash_cooldown_buff
			if RunManager.player.dash_cooldown < 0.01:
				RunManager.player.dash_cooldown = 0.01
		
		queue_free()
		picked_up.emit(item_name, desc)
