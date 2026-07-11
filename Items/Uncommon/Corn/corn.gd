# Transforms bullets into Corn, boosts damage mult, projectile speed, and accuracy
extends Item
class_name Corn

var damage_buff : float = 1.5
var damage_mult_buff : float = 2.5
var accuracy_buff : float = 0.04
var proj_speed_buff : float = 500
var proj_speed_light_buff : float = 100
var fire_rate_debuff : float = 0.4
var fire_rate_light_debuff : float = 0.05


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Corn"
		
		if RunManager.player.items.has("Corn"):
			desc = "+ Damage"
			RunManager.player.add_item_to_array(item_name)
			RunManager.player.current_bullet = RunManager.player.Bullets.CORN
			
			RunManager.player.damage += damage_buff
			RunManager.player.fire_rate += fire_rate_light_debuff
			RunManager.player.bullet_speed += proj_speed_light_buff
		
		else:
			desc = "Bullets become Corn"
			RunManager.player.add_item_to_array(item_name)
			RunManager.player.current_bullet = RunManager.player.Bullets.CORN
			
			RunManager.player.damage_mult += damage_mult_buff
			RunManager.player.fire_rate += fire_rate_debuff
			RunManager.player.bullet_speed += proj_speed_buff
			
			RunManager.player.accuracy.x += accuracy_buff
			if RunManager.player.accuracy.x > 0:
				RunManager.player.accuracy.x = 0
			
			RunManager.player.accuracy.y -= accuracy_buff
			if RunManager.player.accuracy.y < 0:
				RunManager.player.accuracy.y = 0
		
		queue_free()
		picked_up.emit(item_name, desc)
