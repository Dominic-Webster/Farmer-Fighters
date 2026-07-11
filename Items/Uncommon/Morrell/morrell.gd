# Unlocks Spiral Bullets, or boosts bullet speed
extends Item
class_name Morrell

var proj_speed_buff : float = 300

func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Morrell"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.spiral == false:
			desc = "Spiral Bullets"
			RunManager.player.spiral = true
		else:
			desc = "+ Bullet Speed"
			RunManager.player.bullet_speed += proj_speed_buff
		
		queue_free()
		picked_up.emit(item_name, desc)
