extends Camera3D

@export var gridmap: GridMap
@export var turret_manager: Node3D
@export var turret_cost := 100
@export var quick_turret_cost := 150

@export var turret_scene: PackedScene
@export var turret_quick_scene: PackedScene
@export var ghost_material_can_build: StandardMaterial3D
@export var ghost_material_cannot_build: StandardMaterial3D
var _ghost_turret: Node3D = null

@onready var ray_cast_3d = $RayCast3D
@onready var bank = get_tree().get_first_node_in_group("bank")

var selected_turret_type: String = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("right_click"):
		selected_turret_type = ""
		print("Turret selection cleared")
		if is_instance_valid(_ghost_turret):
			_ghost_turret.queue_free()
			_ghost_turret = null
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	ray_cast_3d.target_position = project_local_ray_normal(mouse_position) * 100.0
	ray_cast_3d.force_raycast_update()
	
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
	if not is_instance_valid(_ghost_turret):
		return
	_ghost_turret.visible = false
	var current_cost = 0
	if selected_turret_type == "normal":
		current_cost = turret_cost
	elif selected_turret_type == "quick":
		current_cost = quick_turret_cost
	if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider() is GridMap:
		_ghost_turret.visible = true
		
		var collision_point = ray_cast_3d.get_collision_point()
		var cell = gridmap.local_to_map(collision_point)
		var tile_position = gridmap.map_to_local(cell)
		_ghost_turret.global_position = tile_position
		
		var has_gold = bank.gold >= current_cost
		var is_empty = gridmap.get_cell_item(cell) == 0
		
		if is_empty and has_gold:
			_set_ghost_material(_ghost_turret, ghost_material_can_build)
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
			
			if Input.is_action_just_pressed("click"):
				gridmap.set_cell_item(cell, 1)
				bank.gold -= current_cost
				
				if selected_turret_type == "normal":
					turret_manager.build_turret(tile_position)
				elif selected_turret_type == "quick":
					turret_manager.build_turret_quick(tile_position)
		
		else:
			_set_ghost_material(_ghost_turret, ghost_material_cannot_build)

func _on_build_turret_pressed():
	selected_turret_type = "normal"
	spawn_ghost_turret(turret_scene)
	
	
func _on_build_turret_quick_pressed():
	selected_turret_type = "quick"
	spawn_ghost_turret(turret_quick_scene)
	
	
func spawn_ghost_turret(scene: PackedScene):
	if is_instance_valid(_ghost_turret):
		_ghost_turret.queue_free()
	if scene:
		_ghost_turret = scene.instantiate()
		_set_ghost_material(_ghost_turret, ghost_material_cannot_build)
		turret_manager.add_child(_ghost_turret)
		_ghost_turret.visible = false
		
		
func _set_ghost_material(node: Node, material: StandardMaterial3D):
	if node is MeshInstance3D:
		node.material_override = material
	for child in node.get_children():
		_set_ghost_material(child, material)
