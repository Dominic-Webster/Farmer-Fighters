extends Control
class_name HeartGUI

enum DisplayKind {
	BASE,
	TEMP
}

@onready var sprite: Sprite2D = $Sprite2D

var heart_num : int = 2

var value : int = 2
var heart_type : int = 0 # 0 = TOMATO, 1 = CARROT
var display_kind : DisplayKind = DisplayKind.BASE

func _ready() -> void:
	sprite.scale = Vector2(2.5, 2.5)


func set_heart(_value: int, _heart_type: Variant = null, _display_kind: Variant = null) -> void:
	value = _value
	if _heart_type != null:
		heart_type = int(_heart_type)
	if _display_kind != null:
		display_kind = _display_kind as DisplayKind
	update_sprite()


func update_sprite() -> void:
	var tex = null
	var _scale : float = 2.5
	if display_kind == DisplayKind.TEMP:
		tex = preload("res://GUI/Player_HUD/Avacado.png")
		_scale = 4.75
		sprite.hframes = 2
		sprite.vframes = 1
		if value <= 0:
			sprite.visible = false
			return
		sprite.frame = 0 if value >= 2 else 1
		if sprite.texture != tex:
			sprite.texture = tex
			sprite.scale = Vector2(_scale, _scale)
		sprite.visible = true
		return

	match RunManager.player.current_heart:
		RunManager.player.Hearts.TOMATO:
			tex = preload("res://GUI/Player_HUD/Tomato_health.png")
			_scale = 2.5
		RunManager.player.Hearts.CARROT:
			tex = preload("res://GUI/Player_HUD/carrot_health.png")
			_scale = 4
	sprite.hframes = 2
	sprite.vframes = 2
	if sprite.texture != tex:
		sprite.texture = tex
		sprite.scale = Vector2(_scale, _scale)
	sprite.frame = value
	sprite.visible = true
