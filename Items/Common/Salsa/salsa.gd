# Boosts move speed, damage, damage mult, and fire rate
extends Item
class_name Salsa

var move_speed_boost : float = 75
var damage_boost : float = 0.25
var damage_mult_boost : float = 0.25
var fire_rate_boost : float = 0.05


func get_item_desc() -> String:
	return "+75 Movement Speed\n+0.25 Damage\n+0.25 Damage Mult\n0.05 Fire Rate Buff"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Salsa"
		RunManager.player.add_item_to_array(item_name)
		
		RunManager.player.move_speed += move_speed_boost
		RunManager.player.damage += damage_boost
		RunManager.player.damage_mult += damage_mult_boost
		RunManager.player.fire_rate -= fire_rate_boost
		if RunManager.player.fire_rate < 0.01:
			RunManager.player.fire_rate = 0.01
		
		if MetaManager != null:
			MetaManager.record_item_pickup("salsa")
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
