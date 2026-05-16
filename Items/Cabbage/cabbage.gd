extends Item
class_name Cabbage

var item_name : String = "Cabbage"
var desc : String = "Bullets become Cabbages"
var damage_buff : float = 1
var accuracy_buff : float = 0.02


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.current_bullet = RunManager.player.Bullets.CABBAGE
		
		if RunManager.player.fire_rate < 0.05:
			RunManager.player.fire_rate = 0.1
		elif RunManager.player.fire_rate > 0.2:
			RunManager.player.fire_rate += 0.01
		else:
			RunManager.player.fire_rate *= 1.5
		
		RunManager.player.damage += damage_buff
		
		RunManager.player.accuracy.x += accuracy_buff
		if RunManager.player.accuracy.x > 0:
			RunManager.player.accuracy.x = 0
		
		RunManager.player.accuracy.y -= accuracy_buff
		if RunManager.player.accuracy.y < 0:
			RunManager.player.accuracy.y = 0
		
		queue_free()
		picked_up.emit()
