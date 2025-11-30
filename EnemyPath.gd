extends Path3D

@export var enemy_scene: PackedScene
@export var difficulty_manager: Node
@export var victory_layer: CanvasLayer
@export var tutorial_layer: CanvasLayer

@onready var timer = $Timer

var _first_enemy_spawned := false

func spawn_enemy() -> void:
	if not _first_enemy_spawned:
		_first_enemy_spawned = true
		if is_instance_valid(tutorial_layer) and GameSettings.show_tutorial:
			tutorial_layer.start_tutorial()
	var new_enemy = enemy_scene.instantiate()
	var current_health = difficulty_manager.get_enemy_health()
	var current_speed = difficulty_manager.get_enemy_speed()
	new_enemy.max_health = current_health
	new_enemy.current_health = current_health
	new_enemy.speed = current_speed
	add_child(new_enemy)
	timer.wait_time = difficulty_manager.get_spawn_time()
	print(new_enemy.current_health)
	new_enemy.tree_exited.connect(enemy_defeated)


func _on_difficulty_manager_stop_spawning_enemies():
	timer.stop()

func enemy_defeated() ->  void:
	if timer.is_stopped():
		for child in get_children():
			if child  is PathFollow3D:
				return
		print("you won!")
		victory_layer.victory()

