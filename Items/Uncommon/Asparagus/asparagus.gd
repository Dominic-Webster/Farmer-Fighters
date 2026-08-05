# Bullets become Stream
extends Item
class_name Asparagus

var damage_buff : float = 0.75


func get_item_desc() -> String:
	if RunManager.player.stream == true:
		return "+0.75 Damage\nFire Rate Buff"
	
	return "Bullets become Stream\nFire Rate Buff"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Asparagus"
		
		if RunManager.player.stream == true:
			RunManager.player.damage += damage_buff
			RunManager.player.fire_rate *= 0.95
		else:
			RunManager.player.stream = true
			RunManager.player.fire_rate *= 0.95
		
		RunManager.player.add_item_to_array(item_name)
		
		if MetaManager != null:
			MetaManager.record_item_pickup("asparagus")
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
