extends Item
class_name Radish

var item_name : String = "Radish"
var desc : String = "Dash (+ Speed)"
var dash_speed_buff : float = 250


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.dash_unlocked == false:
			RunManager.player.dash_unlocked = true
			RunManager.player.dash_speed += 100
		else:
			RunManager.player.dash_speed += dash_speed_buff
		
		queue_free()
		picked_up.emit()
