extends Item
class_name FourLeafClover

var item_name : String = "4 Leaf Clover"
var desc : String = "+ Luck"
var luck_boost : int = 2


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.luck += luck_boost
		queue_free()
		picked_up.emit()
