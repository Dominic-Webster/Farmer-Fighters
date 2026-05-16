extends Item
class_name Scythe

var dash_damage_buff : float = 1


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Scythe"
		desc = "Dash (+ Damage)"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.dash_unlocked == false:
			RunManager.player.dash_unlocked = true
			RunManager.player.dash_damage += dash_damage_buff
		else:
			RunManager.player.dash_damage += dash_damage_buff
		
		queue_free()
		picked_up.emit(item_name, desc)
