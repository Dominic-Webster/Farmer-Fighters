# Player shrinks
extends Item
class_name Lemon

var speed_buff : float = 150
var scale_decrease : float = 0.15

func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Lemon"
		desc = "Smaller... Faster..."
		RunManager.player.add_item_to_array(item_name)
		
		RunManager.player.move_speed += speed_buff
		
		RunManager.player.scale -= Vector2(scale_decrease, scale_decrease)
		if RunManager.player.scale < Vector2(0.5, 0.5):
			RunManager.player.scale = Vector2(0.5, 0.5)
		
		queue_free()
		picked_up.emit(item_name, desc)
