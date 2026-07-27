# Unlocks explosion
extends Item
class_name Cilantro

var explosion_damage_mult_boost : float = 1.5
var fire_rate_debuff : float = 0.15


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.explosion == true:
		return "x1.5 Explosion Damage Mult"

	return "Explosive Bullets\n0.15 Fire Rate Debuff"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Cilantro"
		
		if RunManager.player.explosion == true:
			RunManager.player.explosion_damage_mult *= explosion_damage_mult_boost
		else:
			RunManager.player.explosion = true
			RunManager.player.fire_rate += fire_rate_debuff
		
		RunManager.player.add_item_to_array(item_name)
		queue_free()
		picked_up.emit(item_name, get_item_desc())
