# Unlocks Homing, or boosts damage and damage mult
extends Item
class_name Cucumber

var damage_boost : float = 0.5
var damage_mult_boost : float = 0.5

var fire_rate_debuff : float = 0.2
var damage_mult_debuff : float = 0.1


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Cucumber"
		
		if RunManager.player.homing == true:
			desc = "+ Damage"
			RunManager.player.damage += damage_boost
			RunManager.player.damage_mult += damage_mult_boost
		else:
			desc = "Homing Bullets"
			RunManager.player.homing = true
			RunManager.player.fire_rate += fire_rate_debuff
			RunManager.player.damage_mult -= damage_mult_debuff
			if RunManager.player.damage_mult < 0.1:
				RunManager.player.damage_mult = 0.1
		
		RunManager.player.add_item_to_array(item_name)
		queue_free()
		picked_up.emit(item_name, desc)
