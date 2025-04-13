extends CharacterBody2D

@export var speed: int = 500
var ball

func _ready():
	ball = get_parent().get_node("Ball")

func _physics_process(delta: float) -> void:
	velocity.x = 0

	if is_instance_valid(ball) and ball.started:
		if Input.is_action_pressed("MoveLeft"):
			velocity.x -= speed

		if Input.is_action_pressed("MoveRight"):
			velocity.x += speed

	move_and_collide(velocity * delta)
