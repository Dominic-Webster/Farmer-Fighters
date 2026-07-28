# Unlocks Spiral Bullets, or boosts bullet speed
extends Item
class_name Morrell

var proj_speed_buff : float = 300


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.spiral == false:
		return "Unlock Spiral Bullets"

	return "+300 Bullet Speed"

func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Morrell"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.spiral == false:
			RunManager.player.spiral = true
		else:
			RunManager.player.bullet_speed += proj_speed_buff
		
		if MetaManager != null:
			MetaManager.record_item_pickup("morrell")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
