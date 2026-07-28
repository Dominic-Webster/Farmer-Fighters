# Unlocks dual-shot, or boosts damage
extends Item
class_name HoneynutSquash

var damage_buff : float = 0.5
var fire_rate_debuff : float = 0.3
var fire_rate_light_debuff : float = 0.1


func get_item_desc() -> String:
	if RunManager.player != null:
		if RunManager.player.dual_shot == false:
			return "Unlock Dual-Shot\n0.3 Fire Rate Debuff"
		if RunManager.player.tri_shot == false:
			return "Unlock Tri-Shot\n0.3 Fire Rate Debuff"
		if RunManager.player.quad_shot == false:
			return "Unlock Quad-Shot\n+0.1 Damage\n0.1 Fire Rate Debuff"
		if RunManager.player.five_shot == false:
			return "Unlock Five-Shot\n+0.1 Damage"
	
	return "+0.5 Damage\n0.1 Fire Rate Debuff"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Honeynut Squash"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.dual_shot == false:
			RunManager.player.dual_shot = true
			RunManager.player.fire_rate += fire_rate_debuff
		elif RunManager.player.tri_shot == false:
			RunManager.player.tri_shot = true
			RunManager.player.fire_rate += fire_rate_debuff
		elif RunManager.player.quad_shot == false:
			RunManager.player.quad_shot = true
			RunManager.player.fire_rate += fire_rate_light_debuff
			RunManager.player.damage += 0.1
		elif RunManager.player.five_shot == false:
			RunManager.player.five_shot = true
			RunManager.player.damage += 0.1
		else:
			RunManager.player.damage += damage_buff
			RunManager.player.fire_rate += fire_rate_light_debuff
		
		if MetaManager != null:
			MetaManager.record_item_pickup("honeynut_squash")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
