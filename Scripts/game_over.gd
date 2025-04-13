extends Node2D

@onready var score_label = $Score
@onready var best_score_label = $BestScore

func _ready():
	if score_label:
		var best_score = load_best_score()
		best_score_label.text = "BEST SCORE: " + str(best_score)

func set_score(score: int):
	if score_label:
		score_label.text = "SCORE: " + str(score)
		update_best_score(score)

func update_best_score(current_score: int):
	var best_score = load_best_score()
	if current_score > best_score:
		save_best_score(current_score)
		if best_score_label:
			best_score_label.text = "BEST SCORE: " + str(current_score)

func save_best_score(score: int):
	var save_file = FileAccess.open("user://best_score.dat", FileAccess.WRITE)
	if save_file:
		save_file.store_var(score)
		save_file.close()

func load_best_score() -> int:
	var save_file = FileAccess.open("user://best_score.dat", FileAccess.READ)
	var best_score = 0

	if save_file:
		best_score = save_file.get_var()
		save_file.close()
	if typeof(best_score) == TYPE_INT:
		return best_score
	return 0

func _input(event):
	if event.is_action_pressed("Start") and visible:
		get_tree().reload_current_scene()
