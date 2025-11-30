extends CanvasLayer

@onready var difficulty_label = $CenterContainer/PanelContainer/VBoxContainer/DifficultyLabel
@onready var resume_button = $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer/ResumeButton
@onready var quit_button = $CenterContainer/PanelContainer/VBoxContainer/HBoxContainer/QuitButton

func _ready():
	resume_button.pressed.connect(_on_resume_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	_set_difficulty_text()

func _set_difficulty_text():
	var difficulty_string = "Unknown"
	
	match GameSettings.selected_difficulty_index:
		0:
			difficulty_string = "Easy"
		1:
			difficulty_string = "Normal"
		2:
			difficulty_string = "Hard"
			
	difficulty_label.text = "Difficulty: " + difficulty_string

func _on_resume_pressed():
	get_tree().paused = false
	queue_free()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().quit()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_resume_pressed()
		get_viewport().set_input_as_handled()
