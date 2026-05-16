extends Item
class_name GreenBean

var item_name : String = "Green Bean"
var desc : String = "Dash (+ Duration)"
var dash_duration_buff : float = 0.05


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.dash_unlocked == false:
			RunManager.player.dash_unlocked = true
			RunManager.player.dash_duration += 0.01
		else:
			RunManager.player.dash_duration += dash_duration_buff
		
		queue_free()
		picked_up.emit()
