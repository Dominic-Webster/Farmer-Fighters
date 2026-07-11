extends EnemyBullet

@onready var sprite : Sprite2D = $Sprite2D

func _ready() -> void:
	super._ready()
	if randi_range(1, 2) == 1:
		sprite.frame = 1
