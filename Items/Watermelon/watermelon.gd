# Turns Bullets into Watermelon, unlocks bounce
extends Item
class_name Watermelon


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Watermelon"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.current_bullet = RunManager.player.Bullets.WATERMELON
		
		if RunManager.player.spiral == true:
			desc = "+ Damage"
			RunManager.player.damage += 0.5
		elif RunManager.player.bounce == 0:
			desc = "Bullets Bounce"
			RunManager.player.bounce += 1
		else:
			desc = "+ Bounce"
			RunManager.player.bounce += 1
		
		queue_free()
		picked_up.emit(item_name, desc)
