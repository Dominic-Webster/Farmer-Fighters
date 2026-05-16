extends Item
class_name Fertilizer

var item_name : String = "Fertilizer"
var desc : String = "+ Bullet Speed"
var speed_boost : int = 200


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.bullet_speed += speed_boost
		queue_free()
		picked_up.emit()
