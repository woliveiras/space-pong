extends Area2D

@export var speed: float = 150
@export var rotation_speed: float = 1.3

@onready var timer_delete = $TimerDelete
@onready var audio_collision_ball = $AudioCollisionBall
@onready var sprite_2d = $Sprite2D

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
	if body.has_method("set_velocity"):  # Verifica se o corpo tem o método para alterar a velocidade
		# Altere a direção da bola para um lado aleatório
		var new_direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
		body.set_velocity(new_direction * body.velocity.length())  # Ajusta a velocidade da bola

	audio_collision_ball.play()
	sprite_2d.visible = false  # Torna o sprite invisível após a colisão

func _on_audio_collision_ball_finished() -> void:
	queue_free()
