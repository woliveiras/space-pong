extends Node2D

@onready var ball = $Ball
@onready var label_pongs = $Pongs
@onready var label_tutorial = $Tutorial
@onready var positions = $Positions
var last_position 
var asteroid_scene = preload("res://Scenes/asteroid.tscn")

func _process(delta: float) -> void:
	if ball.started:
		label_pongs.visible = true
		label_tutorial.visible = false
			
	label_pongs.text = str(ball.pongs)

func _on_holle_body_entered(body: Node2D) -> void:
	call_deferred("reload_scene")

func reload_scene():
	get_tree().reload_current_scene()

func _on_timer_spawner_timeout() -> void:
	spawn_asteroid()

func spawn_asteroid():
	if (ball.started == true):
		var positions_list = positions.get_children()
		var spawn_position = positions_list.pick_random()
		
		if (spawn_position != last_position):
			var asteroid_instance = asteroid_scene.instantiate()
			asteroid_instance.global_position = spawn_position.position
			add_child(asteroid_instance)
			last_position = spawn_position
		else:
			spawn_asteroid()
