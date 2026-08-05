# Transforms bullets into Cabbages, boosts damage and accuracy
extends Item
class_name Cabbage

var damage_buff : float = 1
var accuracy_buff : float = 0.02


func get_item_desc() -> String:
	if RunManager.player.current_bullet == RunManager.player.Bullets.CABBAGE:
		return "+1 Damage\n0.02 Accuracy Buff\nFire Rate Debuff"
	
	if RunManager.player.stream == true:
		return "Stream Widens\n+1 Damage\n0.02 Accuracy Buff\nFire Rate Debuff"
	
	return "Bullets become Cabbages\n+1 Damage\n0.02 Accuracy Buff\nFire Rate Debuff"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Cabbage"
		
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.current_bullet = RunManager.player.Bullets.CABBAGE
		RunManager.player.set_stream_color(Color(0.2, 0.643, 0.2, 0.902))
		RunManager.player.change_stream_width(2.0)
		
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
		
		if MetaManager != null:
			MetaManager.record_item_pickup("cabbage")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
