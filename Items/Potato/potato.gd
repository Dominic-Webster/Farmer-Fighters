# Turns bullets into Potatoes, unlocks explosion
extends Item
class_name Potato

var explosion_damage_boost : float = 3
var fire_rate_debuff : float = 0.2


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Potato"
		RunManager.player.current_bullet = RunManager.player.Bullets.POTATO
		
		if RunManager.player.items.has("Potato"):
			desc = "+ Explosion Damage"
			RunManager.player.explosion_damage += explosion_damage_boost
		else:
			RunManager.player.potato = true
			desc = "EXPLOSIVE POTATOES"
			RunManager.player.fire_rate += fire_rate_debuff
		
		RunManager.player.add_item_to_array(item_name)
		queue_free()
		picked_up.emit(item_name, desc)
