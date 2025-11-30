extends Node3D

@export var pause_menu_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true

func _unhandled_input(event):
	if event.is_action_pressed("pause") and not get_tree().is_paused():
		get_tree().paused = true
		var pause_menu = pause_menu_scene.instantiate()
		add_child(pause_menu)
		get_viewport().set_input_as_handled
