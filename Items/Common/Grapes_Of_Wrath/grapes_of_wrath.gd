# Turns bullets into grapes, machine gun fire
extends Item
class_name GrapesOfWrath

var damage_nerf : float = 0.5
var fire_rate_buff : float = 0.35
var accuracy_debuff : float = 0.05


func get_item_desc() -> String:
	if RunManager.player.stream == true:
		return "0.35 Fire Rate Buff\n-0.5 Damage\n0.05 Accuracy Debuff"
	
	return "Bullets become Grapes\n0.35 Fire Rate Buff\n-0.5 Damage\n0.05 Accuracy Debuff"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Grapes Of Wrath"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.current_bullet = RunManager.player.Bullets.GRAPE
		RunManager.player.set_stream_color(Color(0.376, 0.18, 0.886, 0.902))
		
		RunManager.player.fire_rate *= fire_rate_buff
		if RunManager.player.fire_rate < 0.01:
			RunManager.player.fire_rate = 0.01
		
		RunManager.player.damage -= damage_nerf
		if RunManager.player.damage < 0.25:
			RunManager.player.damage = 0.25
		
		RunManager.player.accuracy.x -= accuracy_debuff
		RunManager.player.accuracy.y += accuracy_debuff
		
		if MetaManager != null:
			MetaManager.record_item_pickup("grapes_of_wrath")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
