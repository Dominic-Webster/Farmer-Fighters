extends Item
class_name GrapesOfWrath

var damage_nerf : float = 0.5
var fire_rate_buff : float = 0.15
var accuracy_debuff : float = 0.05


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Grapes Of Wrath"
		desc = "+ Bullets become Grapes"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.current_bullet = RunManager.player.Bullets.GRAPE
		
		RunManager.player.fire_rate -= fire_rate_buff
		if RunManager.player.fire_rate < 0.01:
			RunManager.player.fire_rate = 0.01
		
		RunManager.player.damage -= damage_nerf
		if RunManager.player.damage < 0.1:
			RunManager.player.damage = 0.1
		
		RunManager.player.accuracy.x -= accuracy_debuff
		RunManager.player.accuracy.y += accuracy_debuff
		
		queue_free()
		picked_up.emit(item_name, desc)
