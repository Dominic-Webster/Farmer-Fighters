# Fire Rate and Damage Buff
extends Item
class_name Celery

var damage_buff : float = 0.75
var fire_rate_buff : float = 0.05


func get_item_desc() -> String:
	return "+0.75 Damage\n0.05 Fire Rate Buff"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Celery"
		
		RunManager.player.damage += damage_buff
		RunManager.player.fire_rate -= fire_rate_buff
		if RunManager.player.fire_rate < 0.01:
			RunManager.player.fire_rate = 0.01
		
		RunManager.player.add_item_to_array(item_name)
		
		if MetaManager != null:
			MetaManager.record_item_pickup("celery")
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
