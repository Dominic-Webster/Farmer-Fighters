# Boosts move speed, damage, damage mult, and fire rate
extends Item
class_name Salsa

var move_speed_boost : float = 75
var damage_boost : float = 0.25
var damage_mult_boost : float = 0.25
var fire_rate_boost : float = 0.5


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Salsa"
		desc = "+ Stats"
		RunManager.player.add_item_to_array(item_name)
		
		RunManager.player.move_speed += move_speed_boost
		RunManager.player.damage += damage_boost
		RunManager.player.damage_mult += damage_mult_boost
		RunManager.player.fire_rate -= fire_rate_boost
		if RunManager.player.fire_rate < 0.01:
			RunManager.player.fire_rate = 0.01
		
		queue_free()
		picked_up.emit(item_name, desc)
