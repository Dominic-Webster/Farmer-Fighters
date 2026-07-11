# Boosts luck and movement speed
extends Item
class_name Orange

var luck_boost : int = 1
var move_speed_boost : float = 75


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Orange"
		desc = "+ Movement Speed"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.luck += luck_boost
		RunManager.player.move_speed += move_speed_boost
		queue_free()
		picked_up.emit(item_name, desc)
