extends PathFollow3D

@export var speed: float = 5.0
@export var max_health := 50
var current_health: int:
	set(health_in):
		current_health = health_in
		if current_health < 1:
			queue_free()


@onready var base = get_tree().get_first_node_in_group("base")

func _ready() -> void:
	current_health = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += delta * speed
	if progress_ratio == 1.0:
		base.take_damage()
		set_process(false)
