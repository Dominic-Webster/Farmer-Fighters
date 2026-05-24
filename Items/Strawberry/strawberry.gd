extends Item
class_name Strawberry

var damage_buff : float = 0.25
var accuracy_buff : float = 0.005

func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Strawberry"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.current_bullet = RunManager.player.Bullets.STRAWBERRY
		
		if RunManager.player.strawberry == false:
			desc = "Piercing Bullets"
			RunManager.player.strawberry = true
		else:
			desc = "+ Damage"
			RunManager.player.damage += damage_buff
		
		RunManager.player.accuracy.x += accuracy_buff
		if RunManager.player.accuracy.x > 0:
			RunManager.player.accuracy.x = 0
		
		RunManager.player.accuracy.y -= accuracy_buff
		if RunManager.player.accuracy.y < 0:
			RunManager.player.accuracy.y = 0
		
		queue_free()
		picked_up.emit(item_name, desc)
