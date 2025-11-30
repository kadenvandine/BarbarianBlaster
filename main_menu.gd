extends CanvasLayer

@onready var difficulty_dropdown = $CenterContainer/PanelContainer/VBoxContainer/DifficultyDropdown
@onready var play_button = $CenterContainer/PanelContainer/VBoxContainer/PlayButton

@export var game_scene_path := "res://baselevel.tscn"

func _ready():
	difficulty_dropdown.add_item("Easy", 0)
	difficulty_dropdown.add_item("Normal", 1)
	difficulty_dropdown.add_item("Hard", 2)
	
	difficulty_dropdown.select(GameSettings.selected_difficulty_index)
	
	difficulty_dropdown.item_selected.connect(_on_difficulty_selected)
	play_button.pressed.connect(_on_play_pressed)
	
func _on_difficulty_selected(index: int):
	GameSettings.set_difficulty_index(index)
	
func _on_play_pressed():
	get_tree().paused = false
	queue_free()
