# Turns Bullets into Bananas, boomerang
extends Item
class_name Banana

var bullet_speed_buff : float = 200


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.boomerang == true:
		return "+200 Bullet Speed"
	
	return "Bullets become Bananas\nBoomerang Effect Unlocked"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Banana"
		RunManager.player.current_bullet = RunManager.player.Bullets.BANANA
		
		if RunManager.player.boomerang == true:
			RunManager.player.bullet_speed += bullet_speed_buff
		else:
			RunManager.player.boomerang = true
		
		RunManager.player.add_item_to_array(item_name)
		if MetaManager != null:
			MetaManager.record_item_pickup("banana")
		queue_free()
		picked_up.emit(item_name, get_item_desc())
