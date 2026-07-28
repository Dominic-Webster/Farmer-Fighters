# Turns Bullets into Watermelon, unlocks bounce
extends Item
class_name Watermelon


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.spiral == true:
		return "+0.5 Damage"
	if RunManager.player != null and RunManager.player.bounce == 0:
		return "Bullets Bounce"
	return "+1 Bounce"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Watermelon"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.current_bullet = RunManager.player.Bullets.WATERMELON
		
		if RunManager.player.spiral == true:
			RunManager.player.damage += 0.5
		else:
			RunManager.player.bounce += 1
		
		if MetaManager != null:
			MetaManager.record_item_pickup("watermelon")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
