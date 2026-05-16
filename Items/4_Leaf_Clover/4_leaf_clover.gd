extends Item
class_name FourLeafClover

var luck_boost : int = 2


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "4 Leaf Clover"
		desc = "+ Luck"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.luck += luck_boost
		queue_free()
		picked_up.emit(item_name, desc)
