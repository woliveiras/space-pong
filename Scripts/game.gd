extends Node2D

@onready var ball = $Ball
@onready var label_pongs = $Pongs
@onready var label_tutorial = $Tutorial
@onready var positions = $Positions
@onready var background = $Background
@onready var audio_level_up = $AudioLevelUP

var game_is_over: bool = false
var asteroid_scene = preload("res://Scenes/asteroid.tscn")
var game_over = preload("res://Scenes/game_over.tscn")
var res_asteroids = {}
var res_backgrounds = {}
var res_labels = {}

var last_position
var new_asteroid_color
var last_pongs = -1

func _ready() -> void:
	preload_resourses()

func _process(delta: float) -> void:
		if is_instance_valid(ball) and ball.started:
				label_pongs.visible = true
				label_tutorial.visible = false
				check_pongs(ball.pongs)

		if is_instance_valid(ball):
				label_pongs.text = str(ball.pongs)

func _on_holle_body_entered(body: Node2D) -> void:
		if !game_is_over:
				game_is_over = true
				
				var final_score = 0 
				if is_instance_valid(ball):
						final_score = ball.pongs 
						ball.queue_free()
				
				var game_over_instance = game_over.instantiate()
				get_tree().get_root().add_child(game_over_instance)
				
				await get_tree().process_frame
				
				if is_instance_valid(game_over_instance) and game_over_instance.has_method("set_score"):
						game_over_instance.set_score(final_score)

func reload_scene():
	get_tree().reload_current_scene()

func _on_timer_spawner_timeout() -> void:
	spawn_asteroid()

func spawn_asteroid():
		if is_instance_valid(ball) and ball.started:
				var positions_list = positions.get_children()
				var spawn_position = positions_list.pick_random()

				if spawn_position != last_position:
						var asteroid_instance = asteroid_scene.instantiate()
						asteroid_instance.global_position = spawn_position.position
						if new_asteroid_color != null:
								asteroid_instance.get_node("Sprite2D").texture = new_asteroid_color

						add_child(asteroid_instance)
						last_position = spawn_position
				else:
						spawn_asteroid()

func preload_resourses():
	res_asteroids = {
		"1": preload("res://Sprites/Asteroide1.png"),
		"2": preload("res://Sprites/Asteroide2.png"),
		"3": preload("res://Sprites/Asteroide3.png"),
		"4": preload("res://Sprites/Asteroide4.png"),
		"5": preload("res://Sprites/Asteroide5.png"),
		"6": preload("res://Sprites/Asteroide6.png"),
	}

	res_backgrounds = {
		"1": preload("res://Sprites/Fundo1.png"),
		"2": preload("res://Sprites/Fundo2.png"),
		"3": preload("res://Sprites/Fundo3.png"),
		"4": preload("res://Sprites/Fundo4.png"),
		"5": preload("res://Sprites/Fundo5.png"),
		"6": preload("res://Sprites/Fundo6.png"),
	}

	res_labels = {
		"1": "7301ec",
		"2": "4196ff",
		"3": "4ea771",
		"4": "fe9c35",
		"5": "ff5d5d",
		"6": "762d79",
	}

func check_pongs(pongs):
		if is_instance_valid(ball) and (pongs != last_pongs and pongs % 10 == 0):
				match pongs:
						0:
								update_colors("1", "1")
						10:
								update_colors("2", "2")
								update_asteroids("2")
						20:
								update_colors("3", "3")
								update_asteroids("3")
						30:
								update_colors("4", "4")
								update_asteroids("4")
						40:
								update_colors("5", "5")
								update_asteroids("5")
						50:
								update_colors("6", "6")
								update_asteroids("6")
				last_pongs = pongs

				if pongs != 0:
						audio_level_up.play()

func update_colors(key_label, key_background):
	label_pongs.label_settings.font_color = res_labels[key_label]
	background.set_texture(res_backgrounds[key_background])

func update_asteroids(key_asteroid):
	var asteroids = get_tree().get_nodes_in_group("asteroids")

	for asteroid in asteroids:
		var sprite_node = asteroid.get_node("Sprite2D")
		if sprite_node:
			sprite_node.texture = res_asteroids[key_asteroid]

	new_asteroid_color = res_asteroids[key_asteroid]
