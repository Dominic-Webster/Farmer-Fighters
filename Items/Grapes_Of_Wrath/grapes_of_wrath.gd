extends Item
class_name GrapesOfWrath

var item_name : String = "Grapes Of Wrath"
var damage_nerf : float = 0.75
var fire_rate_buff : float = 0.6
var accuracy_debuff : float = 0.1


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
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
		picked_up.emit()


		#"res://Items/4_Leaf_Clover/4_Leaf_Clover.tscn",
		#"res://Items/Apple/Apple.tscn",
		#"res://Items/Broccoli/Broccoli.tscn",
		#"res://Items/Fertilizer/Fertilizer.tscn",
		#"res://Items/Good_Soil/Good_Soil.tscn",
		#"res://Items/Grapes_Of_Wrath/Grapes_Of_Wrath.tscn",
		#"res://Items/Habanero/Habanero.tscn"
