# Orbitting Swarm
extends Item
class_name Blackberry

var damage_mult_buff : float = 1.0
var temp_hp_boost : int = 2


func get_item_desc() -> String:
	if RunManager.player.orbit == false:
		if RunManager.player.stream == true:
			return "+2 Damage Mult\n+1 Avocado Heart"
		return "Orbitting Swarms of Bullets"
	
	return "+1 Damage Mult\n+1 Avocado Heart"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Blackberry"
		
		if RunManager.player.orbit == false:
			if RunManager.player.stream == true:
				RunManager.player.damage_mult += 2
				RunManager.player.add_temp_health(temp_hp_boost)
			RunManager.player.orbit = true
		else:
			RunManager.player.damage_mult += damage_mult_buff
			RunManager.player.add_temp_health(temp_hp_boost)
		
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.set_stream_color(Color(0.125, 0.005, 0.186, 0.902))
		
		if MetaManager != null:
			MetaManager.record_item_pickup("blackberry")
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
