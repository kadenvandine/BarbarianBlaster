extends Node3D

@export var projectile: PackedScene
@export var turret_range := 10.0
@export var projectile_damage := 25

var enemy_path: Path3D
var target: PathFollow3D

@onready var animation_player = $AnimationPlayer
@onready var cannon = $TurretBase/TurretTop/Cannon
@onready var turret_base = $TurretBase

func _physics_process(delta: float) -> void:
	target = find_best_target()
	if target:
		turret_base.look_at(target.global_position, Vector3.UP, true)

func _on_timer_timeout():
	if target:
		var shot = projectile.instantiate()
		shot.damage = projectile_damage
		add_child(shot)
		shot.global_position = cannon.global_position
		shot.direction = turret_base.global_transform.basis.z
		animation_player.play("fire")

func find_best_target() -> PathFollow3D:
	#If enemy path hasn't been set yet, don't try to loop
	if not is_instance_valid(enemy_path):
		return null
	
	var best_target = null
	var best_progress = 0
	for enemy in enemy_path.get_children():
		if enemy is PathFollow3D:
			if enemy.progress > best_progress:
				var distance := global_position.distance_to(enemy.global_position)
				if distance < turret_range:
					best_target = enemy
					best_progress = enemy.progress
	return best_target
