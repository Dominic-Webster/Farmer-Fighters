# Unlocks dash, or boosts dash cooldown and fire rate
extends Item
class_name Turnip

var dash_cooldown_buff : float = 0.2
var fire_rate_buff : float = 0.02


func get_item_desc() -> String:
	if RunManager.player.dash_unlocked == false:
		return "Unlock Dash\n-0.05 Dash Cooldown"
	
	return "0.05 Dash Cooldown Buff\n0.02 Fire Rate Buuf"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Turnip"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.dash_unlocked == false:
			RunManager.player.dash_unlocked = true
			RunManager.player.dash_cooldown -= 0.05
			if RunManager.player.dash_cooldown < 0.01:
				RunManager.player.dash_cooldown = 0.01
		else:
			RunManager.player.dash_cooldown -= dash_cooldown_buff
			if RunManager.player.dash_cooldown < 0.01:
				RunManager.player.dash_cooldown = 0.01
			RunManager.player.fire_rate -= fire_rate_buff
			if RunManager.player.fire_rate < 0.01:
				RunManager.player.fire_rate = 0.01
		
		if MetaManager != null:
			MetaManager.record_item_pickup("turnip")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
