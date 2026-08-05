# Transforms bullets into Corn, boosts damage mult, projectile speed, and accuracy
extends Item
class_name Corn

var damage_buff : float = 1.5
var damage_mult_buff : float = 2.5
var accuracy_buff : float = 0.04
var proj_speed_buff : float = 500
var proj_speed_light_buff : float = 100
var fire_rate_debuff : float = 0.4
var fire_rate_light_debuff : float = 0.05


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.items.has("Corn"):
		return "+1.5 Damage\n+100 Bullet Speed\n0.05 Fire Rate Debuff"
	
	if RunManager.player.stream == true:
		return "+2.5 Damage Mult\n0.04 Accuracy Buff\n0.4 Fire Rate Debuff"
	
	return "Bullets become Corn\n+2.5 Damage Mult\n0.04 Accuracy Buff\n0.4 Fire Rate Debuff"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Corn"
		
		RunManager.player.set_stream_color(Color(0.611, 0.512, 0.0, 0.902))
		
		if RunManager.player.items.has("Corn"):
			RunManager.player.add_item_to_array(item_name)
			RunManager.player.current_bullet = RunManager.player.Bullets.CORN
			
			RunManager.player.damage += damage_buff
			RunManager.player.fire_rate += fire_rate_light_debuff
			RunManager.player.bullet_speed += proj_speed_light_buff
		
		else:
			RunManager.player.add_item_to_array(item_name)
			RunManager.player.current_bullet = RunManager.player.Bullets.CORN
			
			RunManager.player.damage_mult += damage_mult_buff
			RunManager.player.fire_rate += fire_rate_debuff
			RunManager.player.bullet_speed += proj_speed_buff
			
			RunManager.player.accuracy.x += accuracy_buff
			if RunManager.player.accuracy.x > 0:
				RunManager.player.accuracy.x = 0
			
			RunManager.player.accuracy.y -= accuracy_buff
			if RunManager.player.accuracy.y < 0:
				RunManager.player.accuracy.y = 0
		
		if MetaManager != null:
			MetaManager.record_item_pickup("corn")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
