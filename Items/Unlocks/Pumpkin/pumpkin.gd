# Bullets become pumpkins
extends Item
class_name Pumpkin

var damage_buff : float = 0.75


func get_item_desc() -> String:
	if RunManager.player.current_bullet == RunManager.player.Bullets.PUMPKIN:
		return "+0.75 Damage"
	return "Bullets become Pumpkins\nFire Rate Buff\nBullet Speed Debuff\nMovement Speed Debuff"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Pumpkin"
		
		RunManager.player.current_bullet = RunManager.player.Bullets.PUMPKIN
		
		if RunManager.player.items.has("Pumpkin"):
			RunManager.player.damage += damage_buff
		else:
			RunManager.player.bullet_speed *= 0.75
			RunManager.player.move_speed *= 0.9
			
			RunManager.player.fire_rate *= 0.8
			if RunManager.player.fire_rate < 0.01:
				RunManager.player.fire_rate = 0.01
		
		if MetaManager != null:
			MetaManager.record_item_pickup("pumpkin")
		
		RunManager.player.add_item_to_array(item_name)
		queue_free()
		picked_up.emit(item_name, get_item_desc())
