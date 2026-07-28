# Unlocks dash, or boosts dash duration and shot accuracy
extends Item
class_name GreenBean

var dash_duration_buff : float = 0.05
var accuracy_buff : float = 0.01


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.dash_unlocked == false:
		return "Unlock Dash\n+0.01 Dash Duration"
	
	return "+0.05 Dash Duration\n0.01 Accuracy Buff"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Green Bean"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.dash_unlocked == false:
			RunManager.player.dash_unlocked = true
			RunManager.player.dash_duration += 0.01
		else:
			RunManager.player.dash_duration += dash_duration_buff
			RunManager.player.accuracy.x += accuracy_buff
			RunManager.player.accuracy.y -= accuracy_buff
		
		if MetaManager != null:
			MetaManager.record_item_pickup("green_bean")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
