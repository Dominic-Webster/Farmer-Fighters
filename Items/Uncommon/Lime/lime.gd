# Player grows
extends Item
class_name Lime

var speed_debuff : float = 0.9
var scale_increase : float = 0.15
var damage_buff : float = 0.5


func get_item_desc() -> String:
	return "+0.5 Damage\nSize Increase\nx0.9 Movement Speed"

func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Lime"
		RunManager.player.add_item_to_array(item_name)
		
		RunManager.player.move_speed *= speed_debuff
		if RunManager.player.move_speed < 300:
			RunManager.player.move_speed = 300
		
		RunManager.player.damage += damage_buff
		
		RunManager.player.scale += Vector2(scale_increase, scale_increase)
		if RunManager.player.scale > Vector2(1.25, 1.25):
			RunManager.player.scale = Vector2(1.25, 1.25)
		
		if MetaManager != null:
			MetaManager.record_item_pickup("lime")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
