# Unlocks dual-shot, or boosts damage
extends Item
class_name HoneynutSquash

var damage_buff : float = 0.5
var fire_rate_debuff : float = 0.3
var fire_rate_light_debuff : float = 0.03

func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Honeynut Squash"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.dual_shot == false:
			desc = "Dual-Shot"
			RunManager.player.dual_shot = true
			RunManager.player.fire_rate += fire_rate_debuff
		elif RunManager.player.tri_shot == false:
			desc = "Tri-Shot"
			RunManager.player.tri_shot = true
			RunManager.player.fire_rate += fire_rate_debuff
		elif RunManager.player.quad_shot == false:
			desc = "Quad-Shot"
			RunManager.player.quad_shot = true
			RunManager.player.fire_rate += fire_rate_light_debuff
			RunManager.player.damage += 0.1
		elif RunManager.player.five_shot == false:
			desc = "Five-Shot"
			RunManager.player.five_shot = true
			RunManager.player.damage += 0.1
		else:
			desc = "+ Damage"
			RunManager.player.damage += damage_buff
			RunManager.player.fire_rate += fire_rate_light_debuff
		
		queue_free()
		picked_up.emit(item_name, desc)
