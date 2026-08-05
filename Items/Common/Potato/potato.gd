# Turns bullets into Potatoes, unlocks explosion
extends Item
class_name Potato

var explosion_damage_boost : float = 3
var fire_rate_debuff : float = 0.2


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.explosion == true:
		return "+ Explosion Damage"
	
	if RunManager.player.stream == true:
		return "Explosive Stream"
	
	return "EXPLOSIVE POTATOES"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Potato"
		RunManager.player.current_bullet = RunManager.player.Bullets.POTATO
		RunManager.player.set_stream_color(Color(0.285, 0.132, 0.0, 0.902))
		
		if RunManager.player.explosion == true:
			RunManager.player.explosion_damage += explosion_damage_boost
		else:
			RunManager.player.explosion = true
			RunManager.player.fire_rate += fire_rate_debuff
		
		RunManager.player.add_item_to_array(item_name)

		if MetaManager != null:
			MetaManager.record_item_pickup("potato")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
