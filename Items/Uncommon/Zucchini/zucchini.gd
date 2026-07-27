# Unlocks tri-shot, or boosts damage
extends Item
class_name Zucchini

var damage_buff : float = 1.0
var fire_rate_debuff : float = 0.2
var fire_rate_light_debuff : float = 0.02


func get_item_desc() -> String:
	if RunManager.player != null:
		if RunManager.player.tri_shot == false:
			return "Unlock Tri-Shot\n0.2 Fire Rate Debuff"
		if RunManager.player.quad_shot == false:
			return "Unlock Quad-Shot\n+0.1 Damage\n0.02 Fire Rate Debuff"
		if RunManager.player.five_shot == false:
			return "Unlock Five-Shot\n+0.1 Damage"

	return "+1 Damage\n0.02 Fire Rate Debuff"

func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Zucchini"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.dual_shot = true
		
		if RunManager.player.tri_shot == false:
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
			MetaManager.record_item_pickup("zucchini")
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
