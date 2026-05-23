extends Control
class_name HeartGUI

@onready var sprite: Sprite2D = $Sprite2D

var heart_num : int = 2

var value : int = 2
var heart_type : int = 0 # 0 = TOMATO, 1 = CARROT


func set_heart(_value: int, _heart_type: Variant = null) -> void:
	value = _value
	if _heart_type != null:
		heart_type = int(_heart_type)
	update_sprite()


func update_sprite() -> void:
	# Set texture based on heart_type
	var tex = null
	var _scale : int = 3
	match RunManager.player.current_heart:
		RunManager.player.Hearts.TOMATO:
			tex = preload("res://GUI/Player_HUD/Tomato_health.png")
			_scale = 3
		RunManager.player.Hearts.CARROT:
			tex = preload("res://GUI/Player_HUD/carrot_health.png")
			_scale = 4
	if sprite.texture != tex:
		sprite.texture = tex
		sprite.scale = Vector2(_scale, _scale)
	sprite.frame = value
