extends PickUp
class_name Lucky_Coin

@onready var sprite : Sprite2D = $Sprite2D

var luck_boost : int = 2


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		pickup_name = "Lucky Coin"
		desc = "+2 Luck"
		RunManager.player.luck += luck_boost
		queue_free()
		picked_up.emit(pickup_name, desc)
