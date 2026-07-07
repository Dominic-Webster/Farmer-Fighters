# Shoot more, less damage
extends Item
class_name Raspberry

var fire_rate_buff : float = 0.2
var proj_speed_boost : float = 800
var damage_mult_nerf : float = 0.5
var damage_nerf : float = 0.25


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Raspberry"
		desc = "More Bullets"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.bullet_speed += proj_speed_boost
		RunManager.player.damage_mult *= damage_mult_nerf
		
		RunManager.player.fire_rate -= fire_rate_buff
		if RunManager.player.fire_rate < 0.01:
			RunManager.player.fire_rate = 0.01
		
		RunManager.player.damage -= damage_nerf
		if RunManager.player.damage < 0.25:
			RunManager.player.damage = 0.25
		
		queue_free()
		picked_up.emit(item_name, desc)
