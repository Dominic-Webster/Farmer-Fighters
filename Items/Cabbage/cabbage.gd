extends Item
class_name Cabbage

var item_name : String = "Cabbage"
var damage_buff : float = 1
var fire_rate_debuff : float = 0.3
var accuracy_buff : float = 0.01


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.current_bullet = RunManager.player.Bullets.CABBAGE
		
		RunManager.player.fire_rate += fire_rate_debuff
		
		RunManager.player.damage += damage_buff
		
		RunManager.player.accuracy.x += accuracy_buff
		RunManager.player.accuracy.y -= accuracy_buff
		
		queue_free()
		picked_up.emit()
