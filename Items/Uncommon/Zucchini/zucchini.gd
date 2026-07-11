# Unlocks tri-shot, or boosts damage
extends Item
class_name Zucchini

var damage_buff : float = 0.75
var fire_rate_debuff : float = 0.2
var fire_rate_light_debuff : float = 0.02

func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Zucchini"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.tri_shot == false:
			desc = "Tri-Shot"
			RunManager.player.tri_shot = true
			RunManager.player.fire_rate += fire_rate_debuff
		else:
			desc = "+ Damage"
			RunManager.player.damage += damage_buff
			RunManager.player.fire_rate += fire_rate_light_debuff
		
		queue_free()
		picked_up.emit(item_name, desc)
