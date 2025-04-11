extends CharacterBody2D

var started: bool = false
@export var start_speed: float = 500
@export var incremental_speed: float = 1.02
var angle: Array = [-250, 250]

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Start") and started == false:
		start_game()
	
	if started:
		var collision = move_and_collide(velocity * delta)
		
		if collision != null:
			velocity = velocity.bounce(collision.get_normal()) * incremental_speed

func start_game():
	started = true
	velocity.y = -start_speed
	velocity.x = angle.pick_random()
