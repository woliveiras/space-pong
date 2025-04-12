extends CharacterBody2D

@export var start_speed: float = 500
@export var incremental_speed: float = 1.02
@export  var pongs = 0

@onready var audio_impact = $AudioImpact

var max_speed: float = 1500
var started: bool = false
var angle: Array = [-250, 250]

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Start") and started == false:
		start_game()
	
	if started:
		var collision = move_and_collide(velocity * delta)
		
		if collision != null:
			audio_impact.play()
			if collision.get_collider().name == "TopWall":
				if (velocity.length() > max_speed):
					pongs += 1
					velocity = velocity.bounce(collision.get_normal())
				else:
					pongs += 1
					velocity = velocity.bounce(collision.get_normal()) * incremental_speed
			else:
				velocity = velocity.bounce(collision.get_normal())

func start_game():
	started = true
	velocity.y = -start_speed
	velocity.x = angle.pick_random()
