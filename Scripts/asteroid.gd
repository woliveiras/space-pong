extends Area2D

@export var speed: float = 150
@export var rotation_speed: float = 1.3
@onready var timer_delete = $TimerDelete
var start_side

func _ready() -> void:
	if (global_position.x > 540):
		start_side = "right"
	else:
		start_side = "left"

func _process(delta: float) -> void:
	if (start_side == "right"):
		global_position.x -= speed * delta
		rotation -= rotation_speed * delta
	elif (start_side == "left"):
		global_position.x += speed * delta
		rotation += rotation_speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	timer_delete.start()

func _on_timer_delete_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	body.pongs += 1
	queue_free()
	
