# Lets player shoot in more directions, then eventually upgrades damage
extends Item
class_name Eggplant

var fire_rate_nerf : float = 0.1
var damage_buff : float = 0.2


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Eggplant"
		
		if RunManager.player.backshot == true:
			if RunManager.player.five_shot == false and RunManager.player.quad_shot == true:
				RunManager.player.five_shot = true
			elif RunManager.player.quad_shot == false and RunManager.player.tri_shot == true:
				RunManager.player.quad_shot = true
			elif RunManager.player.tri_shot == false and RunManager.player.dual_shot == true:
				RunManager.player.tri_shot = true
			else:
				RunManager.player.dual_shot = true
		
		if RunManager.player.eggplant < 2:
			desc = "More Bullets!"
			RunManager.player.add_item_to_array(item_name)
			
			RunManager.player.fire_rate += fire_rate_nerf
			
			RunManager.player.eggplant += 1
		else:
			desc = "+ Damage"
			RunManager.player.add_item_to_array(item_name)
			RunManager.player.damage += damage_buff
		
		queue_free()
		picked_up.emit(item_name, desc)
