# Boosts move speed, damage, damage mult, and fire rate
extends Item
class_name DaPickle

var move_speed_boost : float = 75
var damage_boost : float = 0.5
var damage_mult_boost : float = 0.5
var fire_rate_boost : float = 0.05
var bullet_speed_boost : float = 150.0
var explosion_dmg_boost : float = 1.0
var bounce_boost : int = 1
var luck_boost : int = 2


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "DA PICKLE"
		desc = "+ Stats"
		RunManager.player.add_item_to_array(item_name)
		
		RunManager.player.move_speed += move_speed_boost
		RunManager.player.damage += damage_boost
		RunManager.player.damage_mult += damage_mult_boost
		RunManager.player.bullet_speed += bullet_speed_boost
		RunManager.player.explosion_damage += explosion_dmg_boost
		RunManager.player.bounce += bounce_boost
		RunManager.player.luck += luck_boost
		RunManager.player.fire_rate -= fire_rate_boost
		if RunManager.player.fire_rate < 0.01:
			RunManager.player.fire_rate = 0.01
		
		queue_free()
		picked_up.emit(item_name, desc)
