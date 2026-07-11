# Player grows
extends Item
class_name Lime

var speed_debuff : float = 0.9
var scale_increase : float = 0.15
var damage_buff : float = 0.5

func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Lime"
		desc = "Bigger... Stronger..."
		RunManager.player.add_item_to_array(item_name)
		
		RunManager.player.move_speed *= speed_debuff
		if RunManager.player.move_speed < 300:
			RunManager.player.move_speed = 300
		
		RunManager.player.damage += damage_buff
		
		RunManager.player.scale += Vector2(scale_increase, scale_increase)
		if RunManager.player.scale > Vector2(1.25, 1.25):
			RunManager.player.scale = Vector2(1.25, 1.25)
		
		queue_free()
		picked_up.emit(item_name, desc)
