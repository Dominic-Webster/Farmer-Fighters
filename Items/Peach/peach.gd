extends Item
class_name Peach

var damage_mult_buff : float = 2.0
var damage_buff : float = 0.25
var accuracy_buff : float = 0.02


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Peach"
		
		if RunManager.player.current_bullet == RunManager.player.Bullets.PEACH:
			desc = "+ Damage"
		else:
			desc = "Bullets become Peaches"
			RunManager.player.current_bullet = RunManager.player.Bullets.PEACH
			
			RunManager.player.bullet_speed *= 0.25
			RunManager.player.fire_rate *= 2
			
			if RunManager.player.fire_rate < 0.05:
				RunManager.player.fire_rate = 0.1
			elif RunManager.player.fire_rate > 0.2:
				RunManager.player.fire_rate += 0.01
			else:
				RunManager.player.fire_rate *= 2.0
			
		RunManager.player.add_item_to_array(item_name)
		
		RunManager.player.damage += damage_buff
		RunManager.player.damage_mult += damage_mult_buff
		
		RunManager.player.accuracy.x += accuracy_buff
		if RunManager.player.accuracy.x > 0:
			RunManager.player.accuracy.x = 0
		
		RunManager.player.accuracy.y -= accuracy_buff
		if RunManager.player.accuracy.y < 0:
			RunManager.player.accuracy.y = 0
		
		queue_free()
		picked_up.emit(item_name, desc)
