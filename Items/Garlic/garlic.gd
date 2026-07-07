# Unlocks Slow_Bullets, or boosts damage
extends Item
class_name Garlic

var damage_buff : float = 0.5


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Garlic"
		
		if RunManager.player.slow_bullets == true:
			desc = "+ Damage"
			RunManager.player.damage += damage_buff
		else:
			desc = "Bullets Slow Enemies"
			RunManager.player.slow_bullets = true
		
		RunManager.player.add_item_to_array(item_name)
		queue_free()
		picked_up.emit(item_name, desc)
