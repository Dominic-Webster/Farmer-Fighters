# Unlocks additional backwards bullet, or increase movement speed
extends Item
class_name Tomatillo

var move_speed_buff : float = 150


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.eggplant > 0 and RunManager.player.dual_shot == false:
		return "Unlock Dual Shot"
	if RunManager.player != null and RunManager.player.backshot == false:
		return "Extra Bullet"

	return "+150 Move Speed"

func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Tomatillo"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.eggplant > 0 and RunManager.player.dual_shot == false:
			RunManager.player.dual_shot = true
			RunManager.player.backshot = true
		elif RunManager.player.backshot == false:
			RunManager.player.backshot = true
		else:
			RunManager.player.move_speed += move_speed_buff
		
		if MetaManager != null:
			MetaManager.record_item_pickup("tomatillo")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
