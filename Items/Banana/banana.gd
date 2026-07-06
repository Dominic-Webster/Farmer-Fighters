# Turns Bullets into Bananas, boomerang
extends Item
class_name Banana

var bullet_speed_buff : float = 200


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Banana"
		RunManager.player.current_bullet = RunManager.player.Bullets.BANANA
		
		if RunManager.player.boomerang == true:
			desc = "Bullet Speed"
			RunManager.player.bullet_speed += bullet_speed_buff
		else:
			RunManager.player.boomerang = true
			desc = "Bullets Boomerang"
		
		RunManager.player.add_item_to_array(item_name)
		queue_free()
		picked_up.emit(item_name, desc)
