# Unlocks additional backwards bullet, or increase movement speed
extends Item
class_name Cherry

var damage_buff : float = 1.5

func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Cherry"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.cherry == false:
			desc = "Enemies shoot Player Bullets on death"
			RunManager.player.cherry = true
		else:
			desc = "+ Damage"
			RunManager.player.damage += damage_buff
		
		queue_free()
		picked_up.emit(item_name, desc)
