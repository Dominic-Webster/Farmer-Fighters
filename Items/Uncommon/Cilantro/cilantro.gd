# Unlocks explosion
extends Item
class_name Cilantro

var explosion_damage_mult_boost : float = 1.5
var fire_rate_debuff : float = 0.15


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Cilantro"
		
		if RunManager.player.explosion == true:
			desc = "+ Explosion Damage Mult"
			RunManager.player.explosion_damage_mult *= explosion_damage_mult_boost
		else:
			RunManager.player.explosion = true
			desc = "Explosive Bullets"
			RunManager.player.fire_rate += fire_rate_debuff
		
		RunManager.player.add_item_to_array(item_name)
		queue_free()
		picked_up.emit(item_name, desc)
