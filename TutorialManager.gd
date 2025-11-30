extends CanvasLayer

enum State {
	INACTIVE,
	STEP_1_ENEMY_INTRO,
	STEP_2_TURRET_BUTTON,
	STEP_3_TURRET_PLACE,
	STEP_4_COMPLETE
}

var current_state = State.INACTIVE

# --- UI Node References ---
@onready var text_bubble = $TextBubble
@onready var tutorial_text = $TextBubble/VBoxContainer/TutorialText
@onready var next_button = $TextBubble/VBoxContainer/NextButton
@onready var skip_tutorial_check = $TextBubble/VBoxContainer/SkipTutorialCheck
@onready var highlight_arrow = $HighlightArrow

# --- Game Node References ---
@export var ray_picker_camera: Camera3D
@export var build_turret_button: Button
@export var quick_turret_button: Button

func _ready():
	visible = false
	next_button.pressed.connect(_on_next_pressed)
	
	if is_instance_valid(ray_picker_camera):
		ray_picker_camera.turret_button_pressed.connect(_on_turret_button_pressed)
		ray_picker_camera.turret_placed.connect(_on_turret_placed)
	else:
		print("TutorialManager: 'Ray Picker Camera' is not assigned!")
		
	if not is_instance_valid(build_turret_button):
		print("TutorialManager: 'Build Turret Button' is not assigned!")

func start_tutorial():
	if current_state == State.INACTIVE:
		set_state(State.STEP_1_ENEMY_INTRO)

func _on_next_pressed():
	match current_state:
		State.STEP_1_ENEMY_INTRO:
			set_state(State.STEP_2_TURRET_BUTTON)
		State.STEP_4_COMPLETE:
			# --- THIS IS THE NEW LOGIC ---
			if skip_tutorial_check.is_pressed():
				# Tell GameSettings to save the "false" value
				GameSettings.set_show_tutorial(false)
			set_state(State.INACTIVE) # Finish the tutorial

func _on_turret_button_pressed():
	if current_state == State.STEP_2_TURRET_BUTTON:
		set_state(State.STEP_3_TURRET_PLACE)

func _on_turret_placed():
	if current_state == State.STEP_3_TURRET_PLACE:
		set_state(State.STEP_4_COMPLETE)

func set_state(new_state: State):
	current_state = new_state
	
	visible = true
	get_tree().paused = true
	next_button.visible = true
	highlight_arrow.visible = false
	skip_tutorial_check.visible = false # <-- Hide by default
	next_button.text = "Next"

	match new_state:
		State.INACTIVE:
			visible = false
			get_tree().paused = false
			print("NEW_STATE")
			if is_instance_valid(build_turret_button):
				build_turret_button.disabled = false
			else:
				print("ERROR: turret button")
			if is_instance_valid(quick_turret_button):
				quick_turret_button.disabled = false
			else:
				print("ERROR: quick turret button")
			print("TUTORIAL OVERRR")
			
		State.STEP_1_ENEMY_INTRO:
			if is_instance_valid(build_turret_button):
				build_turret_button.disabled = true
			if is_instance_valid(quick_turret_button):
				quick_turret_button.disabled = true
			tutorial_text.text = "Here come the barbarians! Your base is under attack. You must defend it!"
			
		State.STEP_2_TURRET_BUTTON:
			tutorial_text.text = "Let's build a turret. Click the 'Turret' button in the top right."
			next_button.visible = false
			_point_arrow_at(build_turret_button)
			if is_instance_valid(build_turret_button):
				build_turret_button.disabled = false
			if is_instance_valid(quick_turret_button):
				quick_turret_button.disabled = false
			
		State.STEP_3_TURRET_PLACE:
			if is_instance_valid(build_turret_button):
				build_turret_button.disabled = true
			if is_instance_valid(quick_turret_button):
				quick_turret_button.disabled = true
			tutorial_text.text = "Great! Now left-click on an empty green tile to place your turret."
			next_button.visible = false
		
		State.STEP_4_COMPLETE:
			if is_instance_valid(build_turret_button):
				build_turret_button.disabled = true
			if is_instance_valid(quick_turret_button):
				quick_turret_button.disabled = true
			tutorial_text.text = "Excellent! Your turret will now attack enemies. Keep placing turrets as the barbarians become more fierce! Good luck!"
			next_button.text = "Finish"
			skip_tutorial_check.visible = true # <-- Show on the last step

# Helper function to move the arrow
func _point_arrow_at(node: Control):
	# (This function is unchanged)
	if not is_instance_valid(node):
		highlight_arrow.visible = false
		return
		
	highlight_arrow.visible = true
	var node_rect = node.get_global_rect()
	highlight_arrow.global_position = node_rect.get_center() - Vector2(node_rect.size.x / 2 + highlight_arrow.size.x + 10, highlight_arrow.size.y / 2)
	highlight_arrow.rotation_degrees = 0
