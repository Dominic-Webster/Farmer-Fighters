# Gives player 2 extra hearts
extends Item
class_name GoodSoil

var health_boost : int = 4


func _ready() -> void:
	add_to_group("item")
	area2d.body_entered.connect(_on_body_entered)
	if RunManager.player.current_heart == RunManager.player.Hearts.CARROT:
		health_boost = 6


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Good Soil"
		desc = "+ Health"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.num_hearts += 2
		RunManager.player.current_health += health_boost
		RunManager.player.healed.emit()
		queue_free()
		picked_up.emit(item_name, desc)
