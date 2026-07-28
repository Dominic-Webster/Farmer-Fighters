extends Item
class_name Peach

var damage_mult_buff : float = 2.0
var damage_buff : float = 0.25
var accuracy_buff : float = 0.02


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.current_bullet == RunManager.player.Bullets.PEACH:
		return "+0.25 Damage\n+2 Damage Mult\n0.02 Accuracy Buff"
	
	return "Bullets become Peaches\n+0.25 Damage\n+2 Damage Mult\n0.02 Accuracy Buff\nFire Rate/Bullet Speed Debuff"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Peach"
		
		if RunManager.player.current_bullet == RunManager.player.Bullets.PEACH:
			RunManager.player.current_bullet = RunManager.player.Bullets.PEACH
			
			RunManager.player.bullet_speed *= 0.25
			RunManager.player.fire_rate *= 2
			
			if RunManager.player.fire_rate < 0.05:
				RunManager.player.fire_rate = 0.1
			elif RunManager.player.fire_rate > 0.2:
				RunManager.player.fire_rate += 0.01
			else:
				RunManager.player.fire_rate *= 2.0
		
		RunManager.player.damage += damage_buff
		RunManager.player.damage_mult += damage_mult_buff
		
		RunManager.player.accuracy.x += accuracy_buff
		if RunManager.player.accuracy.x > 0:
			RunManager.player.accuracy.x = 0
		
		RunManager.player.accuracy.y -= accuracy_buff
		if RunManager.player.accuracy.y < 0:
			RunManager.player.accuracy.y = 0
		
		RunManager.player.add_item_to_array(item_name)
		
		if MetaManager != null:
			MetaManager.record_item_pickup("peach")
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
