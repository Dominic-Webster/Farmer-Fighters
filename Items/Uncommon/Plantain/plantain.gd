# Turns Bullets into Plantains, boomerang
extends Item
class_name Plantain

var bullet_speed_buff : float = 300


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.boomerang == true:
		return "+300 Bullet Speed"
	
	if RunManager.player.stream == true:
		return "Stream Boomerangs"
	
	return "Bullets Boomerang"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Plantain"
		RunManager.player.current_bullet = RunManager.player.Bullets.PLANTAIN
		RunManager.player.set_stream_color(Color(0.129, 0.348, 0.091, 0.902))
		
		if RunManager.player.boomerang == true:
			RunManager.player.bullet_speed += bullet_speed_buff
		else:
			RunManager.player.boomerang = true
		
		if MetaManager != null:
			MetaManager.record_item_pickup("plantain")

		RunManager.player.add_item_to_array(item_name)
		queue_free()
		picked_up.emit(item_name, get_item_desc())
