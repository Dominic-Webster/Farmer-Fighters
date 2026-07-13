extends Resource
class_name PlayerData


@export var name : String
@export var spritesheet : Texture2D

# Stats
@export var num_hearts : int = 3 # Number of hearts
@export var damage : float = 1.0
@export var damage_mult : float = 1.0
@export var luck : int = 1
@export var move_speed : float = 400
@export var fire_rate : float = 0.3
@export var bullet_speed : float = 800
@export var accuracy : Vector2 = Vector2(-0.05, 0.05)

@export var explosion_damage : float = 2.0
@export var explosion_damage_mult : float = 1.0

# Dash Stats
@export var dash_unlocked = false
@export var dash_speed : float = 2500
@export var dash_duration : float = 0.1
@export var dash_damage : float = 0
@export var dash_cooldown_time: float = 0.5

enum Hearts {
	TOMATO,
	CARROT
}

@export var starting_heart : Hearts = Hearts.TOMATO

enum Bullets {
	TOMATO,
	CABBAGE,
	BANANA,
	CORN,
	GRAPE,
	STRAWBERRY,
	PEACH,
	POTATO,
	PLANTAIN,
	WATERMELON
}

@export var starting_bullet : Bullets = Bullets.TOMATO

# Knockback
@export var knockback_strength := 350
@export var knockback_decay := 800


@export var boomerang : bool = false
@export var bounce : int = 0
@export var spiral : bool = false
@export var eggplant : int = 0
@export var piercing : bool = false
@export var dual_shot : bool = false
@export var tri_shot : bool = false
@export var quad_shot : bool = false
@export var five_shot : bool = false
@export var portobello : bool = false
@export var backshot : bool = false
@export var explosion : bool = false
@export var inverse_controls : bool = false

@export var companion_dmg_mult : float = 1.0
@export var cow_unlocked : bool = false
@export var cow_damage : float = 2.0
@export var cow_speed : float = 250

@export var slow_bullets : bool = false

# Companions
#@export var cow_unlocked : bool = false
#@export var cow_damage : float = 2
#@export var cow_speed : float = 400

#@export var chicken_unlocked : bool = false
#@export var chicken_damage : float = 2
#@export var chicken_speed : float = 400
