extends Item
class_name Broccoli

var item_name : String = "Broccoli"
var damage_boost : float = 0.5


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.damage += damage_boost
		queue_free()
		picked_up.emit()
