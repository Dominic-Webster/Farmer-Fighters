extends RefCounted
class_name RunSave

const SAVE_DIR := "user://save/Run"
const SAVE_FILE := SAVE_DIR + "/current_run.save"


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_FILE)


func save_run() -> bool:
	var run_data := build_run_data()
	if run_data.is_empty():
		return false

	DirAccess.make_dir_recursive_absolute(SAVE_DIR)

	var file := FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open run save file for writing: " + SAVE_FILE)
		return false

	file.store_var(run_data, true)
	return true


func load_run() -> Dictionary:
	if not has_save():
		return {}

	var file := FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file == null:
		push_error("Failed to open run save file for reading: " + SAVE_FILE)
		return {}

	var run_data = file.get_var(true)
	if typeof(run_data) != TYPE_DICTIONARY:
		return {}

	return run_data


func clear_save() -> void:
	if has_save():
		DirAccess.remove_absolute(SAVE_FILE)


func build_run_data() -> Dictionary:
	if RunManager == null or RunManager.player == null:
		return {}

	var player_data_path := ""
	if RunManager.player_data != null:
		player_data_path = RunManager.player_data.resource_path

	return {
		"version": 1,
		"run_seed": RunManager.run_seed,
		"difficulty": RunManager.difficulty,
		"current_floor": RunManager.current_floor,
		"current_room": RunManager.current_room,
		"current_entry_dir": RunManager.current_entry_dir,
		"player_position": RunManager.player.global_position,
		"room_history": RunManager.room_history.duplicate(true),
		"room_states": MapGenerationManager.room_states.duplicate(true),
		"dungeon": MapGenerationManager.dungeon.duplicate(true),
		"start": MapGenerationManager._start,
		"player_data_path": player_data_path,
		"player": serialize_player(RunManager.player),
	}


func apply_run_data(run_data: Dictionary) -> bool:
	if run_data.is_empty():
		return false

	RunManager.run_seed = int(run_data.get("run_seed", 0))
	RunManager.difficulty = str(run_data.get("difficulty", ""))
	RunManager.current_floor = int(run_data.get("current_floor", 1))
	RunManager.current_room = run_data.get("current_room", Vector2i.ZERO)
	RunManager.current_entry_dir = str(run_data.get("current_entry_dir", "C"))
	RunManager.room_history = run_data.get("room_history", {}).duplicate(true)
	MapGenerationManager.room_states = run_data.get("room_states", {}).duplicate(true)
	MapGenerationManager.dungeon = run_data.get("dungeon", []).duplicate(true)
	MapGenerationManager._start = run_data.get("start", Vector2i(-1, -1))
	RunManager.rng.seed = RunManager.run_seed

	var player_data_path := str(run_data.get("player_data_path", ""))
	if player_data_path != "":
		var loaded_player_data = load(player_data_path)
		if loaded_player_data is PlayerData:
			RunManager.player_data = loaded_player_data

	if RunManager.player == null:
		RunManager.player = preload("res://player/Player.tscn").instantiate()

	if RunManager.player_data != null:
		RunManager.player.data = RunManager.player_data

	RunManager.player.reset_player()
	apply_player_state(RunManager.player, run_data.get("player", {}))

	return true


func serialize_player(player: Player) -> Dictionary:
	if player == null:
		return {}

	return {
		"char_name": player.char_name,
		"num_hearts": player.num_hearts,
		"damage": player.damage,
		"damage_mult": player.damage_mult,
		"luck": player.luck,
		"move_speed": player.move_speed,
		"fire_rate": player.fire_rate,
		"bullet_speed": player.bullet_speed,
		"accuracy": player.accuracy,
		"shield_unlocked": player.shield_unlocked,
		"shield_on": player.shield_on,
		"explosion_damage": player.explosion_damage,
		"explosion_damage_mult": player.explosion_damage_mult,
		"dash_unlocked": player.dash_unlocked,
		"dash_speed": player.dash_speed,
		"dash_duration": player.dash_duration,
		"dash_damage": player.dash_damage,
		"dash_cooldown_time": player.dash_cooldown_time,
		"current_heart": int(player.current_heart),
		"current_health": player.current_health,
		"temp_health": player.temp_health,
		"current_bullet": int(player.current_bullet),
		"scale": player.scale,
		"items": player.items.duplicate(),
		"knockback_strength": player.knockback_strength,
		"knockback_decay": player.knockback_decay,
		"boomerang": player.boomerang,
		"bounce": player.bounce,
		"spiral": player.spiral,
		"eggplant": player.eggplant,
		"cherry": player.cherry,
		"homing": player.homing,
		"piercing": player.piercing,
		"dual_shot": player.dual_shot,
		"tri_shot": player.tri_shot,
		"quad_shot": player.quad_shot,
		"five_shot": player.five_shot,
		"portobello": player.portobello,
		"backshot": player.backshot,
		"explosion": player.explosion,
		"inverse_controls": player.inverse_controls,
		
		"companion_dmg_mult": player.companion_dmg_mult,
		"cow_unlocked": player.cow_unlocked,
		"cow_damage": player.cow_damage,
		"cow_speed": player.cow_speed,
		"chicken_unlocked": player.chicken_unlocked,
		"chicken_damage": player.chicken_damage,
		"chicken_fire_rate": player.chicken_fire_rate,
		"chicken_bullet_speed": player.chicken_bullet_speed,
		
		"shovel_unlocked": player.shovel_unlocked,
		"shovel_damage": player.shovel_damage,
		"garden_fork_unlocked": player.garden_fork_unlocked,
		"garden_fork_damage": player.garden_fork_damage,
		"trowel_unlocked": player.trowel_unlocked,
		"trowel_damage": player.trowel_damage,
		
		"slow_bullets": player.slow_bullets,
		"stream": player.stream,
		"active_item_id": player.active_item_id,
		"active_item_name": player.active_item_name,
		"active_item_desc": player.active_item_desc,
		"active_item_texture_path": player.active_item_texture_path,
		"active_item_charges": player.active_item_charges,
		"active_item_max_charges": player.active_item_max_charges,
	}


func apply_player_state(player: Player, player_state: Dictionary) -> void:
	if player == null or player_state.is_empty():
		return

	player.char_name = str(player_state.get("char_name", player.char_name))
	player.num_hearts = int(player_state.get("num_hearts", player.num_hearts))
	player.damage = float(player_state.get("damage", player.damage))
	player.damage_mult = float(player_state.get("damage_mult", player.damage_mult))
	player.luck = int(player_state.get("luck", player.luck))
	player.move_speed = float(player_state.get("move_speed", player.move_speed))
	player.fire_rate = float(player_state.get("fire_rate", player.fire_rate))
	player.bullet_speed = float(player_state.get("bullet_speed", player.bullet_speed))
	player.accuracy = player_state.get("accuracy", player.accuracy)
	player.shield_unlocked = player_state.get("shield_unlocked", player.shield_unlocked)
	player.shield_on = player_state.get("shield_on", player.shield_on)
	player.explosion_damage = float(player_state.get("explosion_damage", player.explosion_damage))
	player.explosion_damage_mult = float(player_state.get("explosion_damage_mult", player.explosion_damage_mult))
	player.dash_unlocked = bool(player_state.get("dash_unlocked", player.dash_unlocked))
	player.dash_speed = float(player_state.get("dash_speed", player.dash_speed))
	player.dash_duration = float(player_state.get("dash_duration", player.dash_duration))
	player.dash_damage = float(player_state.get("dash_damage", player.dash_damage))
	player.dash_cooldown_time = float(player_state.get("dash_cooldown_time", player.dash_cooldown_time))
	player.current_heart = player_state.get("current_heart", player.current_heart) as Player.Hearts
	player.current_health = int(player_state.get("current_health", player.current_health))
	player.temp_health = int(player_state.get("temp_health", player.temp_health))
	player.current_bullet = player_state.get("current_bullet", player.current_bullet) as Player.Bullets
	player.scale = player_state.get("scale", player.scale)
	player.items = player_state.get("items", player.items).duplicate()
	player.knockback_strength = int(player_state.get("knockback_strength", player.knockback_strength))
	player.knockback_decay = int(player_state.get("knockback_decay", player.knockback_decay))
	
	player.boomerang = bool(player_state.get("boomerang", player.boomerang))
	player.bounce = int(player_state.get("bounce", player.bounce))
	player.spiral = bool(player_state.get("spiral", player.spiral))
	player.eggplant = int(player_state.get("eggplant", player.eggplant))
	player.cherry = bool(player_state.get("cherry", player.cherry))
	player.homing = bool(player_state.get("homing", player.homing))
	player.piercing = bool(player_state.get("piercing", player.piercing))
	player.dual_shot = bool(player_state.get("dual_shot", player.dual_shot))
	player.tri_shot = bool(player_state.get("tri_shot", player.tri_shot))
	player.quad_shot = bool(player_state.get("quad_shot", player.quad_shot))
	player.five_shot = bool(player_state.get("five_shot", player.five_shot))
	player.portobello = bool(player_state.get("portobello", player.portobello))
	player.backshot = bool(player_state.get("backshot", player.backshot))
	player.explosion = bool(player_state.get("explosion", player.explosion))
	player.inverse_controls = bool(player_state.get("inverse_controls", player.inverse_controls))
	# Companions
	player.companion_dmg_mult = float(player_state.get("companion_dmg_mult", player.companion_dmg_mult))
	player.cow_unlocked = bool(player_state.get("cow_unlocked", player.cow_unlocked))
	player.cow_damage = float(player_state.get("cow_damage", player.cow_damage))
	player.cow_speed = float(player_state.get("cow_speed", player.cow_speed))
	player.chicken_unlocked = bool(player_state.get("chicken_unlocked", player.chicken_unlocked))
	player.chicken_damage = float(player_state.get("chicken_damage", player.chicken_damage))
	player.chicken_fire_rate = float(player_state.get("chicken_fire_rate", player.chicken_fire_rate))
	player.chicken_bullet_speed = float(player_state.get("chicken_bullet_speed", player.chicken_bullet_speed))
	# Rotators
	player.shovel_unlocked = bool(player_state.get("shovel_unlocked", player.shovel_unlocked))
	player.shovel_damage = float(player_state.get("shovel_damage", player.shovel_damage))
	player.garden_fork_unlocked = bool(player_state.get("garden_fork_unlocked", player.garden_fork_unlocked))
	player.garden_fork_damage = float(player_state.get("garden_fork_damage", player.garden_fork_damage))
	player.trowel_unlocked = bool(player_state.get("trowel_unlocked", player.trowel_unlocked))
	player.trowel_damage = float(player_state.get("trowel_damage", player.trowel_damage))
	
	player.slow_bullets = bool(player_state.get("slow_bullets", player.slow_bullets))
	player.stream = bool(player_state.get("stream", player.stream))
	player.active_item_id = str(player_state.get("active_item_id", player.active_item_id))
	player.active_item_name = str(player_state.get("active_item_name", player.active_item_name))
	player.active_item_desc = str(player_state.get("active_item_desc", player.active_item_desc))
	player.active_item_texture_path = str(player_state.get("active_item_texture_path", player.active_item_texture_path))
	player.active_item_texture = null
	if player.active_item_texture_path != "":
		player.active_item_texture = load(player.active_item_texture_path) as Texture2D
	player.active_item_charges = int(player_state.get("active_item_charges", player.active_item_charges))
	player.active_item_max_charges = int(player_state.get("active_item_max_charges", player.active_item_max_charges))
	player.update_active_item_hud()

	if MetaManager != null:
		MetaManager.record_run_hearts(player.num_hearts)
