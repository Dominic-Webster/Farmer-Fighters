# Unlocks dash, or boosts dash speed and move speed
extends Item
class_name Radish

var dash_speed_buff : float = 250
var move_speed_buff : float = 50


func get_item_desc() -> String:
	if RunManager.player.dash_unlocked == false:
		return "Unlock Dash\n+100 Dash Speed"
	
	return "+100 Dash Speed\n+50 Movement Speed"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Radish"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.dash_unlocked == false:
			RunManager.player.dash_unlocked = true
			RunManager.player.dash_speed += 100
		else:
			RunManager.player.dash_speed += dash_speed_buff
			RunManager.player.move_speed += move_speed_buff
		
		if MetaManager != null:
			MetaManager.record_item_pickup("radish")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
