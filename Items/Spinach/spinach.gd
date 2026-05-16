extends Item
class_name Spinach

var move_speed_boost : float = 100
var damage_boost : float = 0.5
var proj_speed_boost : float = 150


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Spinach"
		desc = "+ Stats"
		RunManager.player.add_item_to_array(item_name)
		
		RunManager.player.move_speed += move_speed_boost
		RunManager.player.damage += damage_boost
		RunManager.player.bullet_speed += proj_speed_boost
		
		queue_free()
		picked_up.emit(item_name, desc)
