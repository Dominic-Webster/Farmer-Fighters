# Unlocks Looping Bullets, and increase damage mult
extends Item
class_name Portobello

var damage_mult_buff : float = 1.5

func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Portobello"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.spiral == true or RunManager.player.portobello == true:
			desc = "+ Damage Mult"
			RunManager.player.damage_mult *= damage_mult_buff
		else:
			desc = "Wavy Bullets"
			RunManager.player.portobello = true
			RunManager.player.damage_mult += 0.5
		
		queue_free()
		picked_up.emit(item_name, desc)
