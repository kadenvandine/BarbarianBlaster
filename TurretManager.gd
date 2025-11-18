extends Node3D

@export var turret: PackedScene
# Called when the node enters the scene tree for the first time.
@export var enemy_path: Path3D

func build_turret(turret_position: Vector3) -> void:
	var new_turret = turret.instantiate()
	add_child(new_turret)
	new_turret.global_position = turret_position
	new_turret.enemy_path = enemy_path

