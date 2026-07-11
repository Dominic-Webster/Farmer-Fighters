# Massive buff, but inverse controls
extends Item
class_name Mirror

var health_boost : int = 2
var damage_boost : float = 2.0
var damage_mult_boost : float = 0.5
var luck_boost : int = 2


func _ready() -> void:
	add_to_group("item")
	area2d.body_entered.connect(_on_body_entered)
	if RunManager.player.current_heart == RunManager.player.Hearts.CARROT:
		health_boost = 3


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Mirror"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.inverse_controls == true:
			desc = "Fortune favors you"
		else:
			desc = "Strength at a price..."
		
		RunManager.player.inverse_controls = !RunManager.player.inverse_controls
		
		RunManager.player.damage += damage_boost
		RunManager.player.damage_mult += damage_mult_boost
		
		RunManager.player.luck += luck_boost
		
		RunManager.player.num_hearts += 1
		RunManager.player.current_health = RunManager.player.get_max_health()
		RunManager.player.damaged.emit()
		
		queue_free()
		picked_up.emit(item_name, desc)
